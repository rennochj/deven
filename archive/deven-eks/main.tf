locals {
  public_key                 = file(pathexpand(var.public_key_file))
  kubernetes_config_expanded = pathexpand(var.kubernetes_config)
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {

  # shared_config_files      = [pathexpand(var.aws_config)]
  # shared_credentials_files = [pathexpand(var.aws_credentials)]
  profile = var.aws_profile
  region  = var.aws_region

}

provider "kubernetes" {
  config_path = local.kubernetes_config_expanded
}

resource "kubernetes_namespace" "deven" {
  metadata {
    name = var.deven_namespace
  }
}

resource "kubernetes_secret" "deven_secret" {
  metadata {
    name      = "package_ghcr_io"
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
    name      = var.deven_instance_name
    namespace = kubernetes_namespace.deven.metadata.0.name
    labels = {
      app = "deven_app"
    }
  }

  spec {

    volume {
      name = "deven_workspace_volume"
      aws_elastic_block_store {
        fs_type   = "xfs"
        partition = 0
        read_only = false
        # volume_id = "${aws_ebs_volume.deven_volume_ebs.id}"
        volume_id = var.deven_workspace_volume_id
      }
    }

    image_pull_secrets {
      name = "package_ghcr_io"
    }

    container {
      image = var.deven_image
      name  = "deven_container"
      volume_mount {
        name       = "deven_workspace_volume"
        mount_path = "/workspace"
      }

      port {
        container_port = 22
      }
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
    KUBECONFIG="${local.kubernetes-config-expanded}" kubectl exec --namespace=${var.deven_namespace} ${var.deven_instance_name} -- bash -c "echo '${local.public_key}' > /home/deven/.ssh/authorized_keys"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
    KUBECONFIG="${local.kubernetes_config_expanded}" kubectl exec --namespace=${var.deven_namespace} ${var.deven_instance_name} -- bash -c "chown -R deven /workspace && chown -R deven /home/deven "
    EOT
  }

}
