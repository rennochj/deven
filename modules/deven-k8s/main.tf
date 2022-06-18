locals {
  private_key                = file("${var.private_key_file}")
  public_key                 = file("${var.private_key_file}.pub")
  kubernetes_config_expanded = pathexpand(var.kubernetes_config)
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path = local.kubernetes_config_expanded
}

resource "kubernetes_secret" "deven_secret" {
  metadata {
    name      = "package-ghcr-io"
    namespace = var.deven_namespace
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

resource "kubernetes_persistent_volume_claim" "deven_workspace_pvc" {

  metadata {
    name      = var.deven_workspace
    namespace = var.deven_namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "${var.deven_workspace_capacity}"
      }
    }
    volume_name = var.deven_workspace
  }

}

resource "kubernetes_pod" "deven" {

  metadata {
    name      = var.deven_instance_name
    namespace = var.deven_namespace
    labels = {
      app = "deven-app"
    }
  }

  spec {

    image_pull_secrets {
      name = "package-ghcr-io"
    }

    container {
      image = var.deven_image
      name  = "deven-container"
      env {
        name  = "SSH_PUBLIC_KEY"
        value = local.public_key
      }
      volume_mount {
        name       = var.deven_workspace
        mount_path = "/workspace"
      }
      port {
        container_port = 22
      }
    }

    volume {
      name = var.deven_workspace
      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim.deven_workspace_pvc.metadata.0.name
      }
    }

    security_context {
      fs_group = 1000
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
    KUBECONFIG="${local.kubernetes_config_expanded}" kubectl exec --namespace=${var.deven_namespace} ${var.deven_instance_name} -- bash -c "deven-initialize"
    KUBECONFIG=${var.kubernetes_config} nohup kubectl port-forward --namespace ${var.deven_namespace} ${var.deven_instance_name} ${var.deven_ssh_port}:22 > /dev/null 2>&1 &
    disown
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
    pkill -f "kubectl port-forward"
    EOT
  }

}

resource "null_resource" "initialization" {

  count = fileexists(var.initial_script) ? 1 : 0

  depends_on = [kubernetes_pod.deven]

  provisioner "remote-exec" {

    connection {

      type        = "ssh"
      user        = "deven"
      private_key = local.private_key
      host        = "localhost"
      port        = var.deven_ssh_port

    }

    script = var.initial_script

  }

}