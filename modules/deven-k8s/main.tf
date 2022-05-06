locals {
  public-key = file(pathexpand(var.public-key-file))
  kubernetes-config-expanded = pathexpand(var.kubernetes-config)
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = local.kubernetes-config-expanded
}

resource "kubernetes_namespace" "deven" {
  metadata {
    name = var.deven-namespace
  }
}

resource "kubernetes_secret" "deven_secret" {
  metadata {
    name      = "package-ghcr-io"
    namespace = kubernetes_namespace.deven.metadata.0.name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode(
      {
        auths = {
          "ghcr.io" = {
            "auth" = base64encode("${var.registry-username}:${var.registry-password}")
          }
        }
      }
    )
  }
}

resource "kubernetes_pod" "deven" {

  metadata {
    name      = var.deven-instance-name
    namespace = kubernetes_namespace.deven.metadata.0.name
    labels = {
      app = "deven-app"
    }
  }

  spec {

    image_pull_secrets {
      name = "package-ghcr-io"
    }

    container {
      image = var.deven-image
      name  = "deven-container"
      volume_mount {
        name       = var.deven-workspace
        mount_path = "/workspace"
      }
      port {
        container_port = 22
      }
    }

    init_container {
      name  = "init-deven-workspace"
      image = "alpine/git"
      volume_mount {
        name       = var.deven-workspace
        mount_path = "/workspace"
      }
      command = [
        "ash", 
        "-c", 
        "cd /workspace && git clone '${var.workspace-git-repo}'"
        ]
    }

    volume {
      name = var.deven-workspace
      empty_dir {}
    }

    security_context {
      fs_group = 1000
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
    KUBECONFIG="${local.kubernetes-config-expanded}" kubectl exec --namespace=${var.deven-namespace} ${var.deven-instance-name} -- bash -c "echo '${local.public-key}' > /home/deven/.ssh/authorized_keys"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
    KUBECONFIG="${local.kubernetes-config-expanded}" kubectl exec --namespace=${var.deven-namespace} ${var.deven-instance-name} -- bash -c "chown -R deven /workspace && chown -R deven /home/deven "
    EOT
  }

}

resource "kubernetes_service" "deven" {
  metadata {
    name      = "deven-service"
    namespace = kubernetes_namespace.deven.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_pod.deven.metadata.0.labels.app
    }
    type = "NodePort"
    port {
      name = "p1"
      node_port   = var.ssh-port
      port        = 22
      target_port = 22
    }
  }
}

