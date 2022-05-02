locals {
  public-key = file(pathexpand(var.public-key-file))
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
  config_path = "/Users/rennochj/.kube/k8s.config"
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
            "auth" = base64encode("${var.registry_username}:${var.registry_password}")
          }
        }
      }
    )
  }
}

resource "kubernetes_pod" "deven" {

  metadata {
    name      = var.deven-pod-name
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
    
    container {
      image = "nginx:latest"
      name  = "deven-web"
      port {
        container_port = 80
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
        "if [ -n '${var.workspace-git-repo-url}' ] ; then git clone ${var.workspace-git-repo-url} /workspace; fi"
        # "git clone ${var.workspace-git-repo-url} /workspace"
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
    KUBECONFIG="/Users/rennochj/.kube/k8s.config" kubectl exec --namespace=${var.deven-namespace} ${var.deven-pod-name} -- bash -c "echo '${local.public-key}' > /home/deven/.ssh/authorized_keys"
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

