locals {
  kubernetes_config_expanded = pathexpand(var.kubernetes_config)
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
  config_path = local.kubernetes_config_expanded
}

resource "kubernetes_namespace" "deven" {
  metadata {
    name = var.deven_namespace
  }
}

resource "kubernetes_persistent_volume" "deven_workspace_pv" {

  metadata {
    name = var.deven_workspace
  }

  spec {
    capacity = {
      storage = "${var.deven_workspace_capacity}"
    }
    access_modes       = ["ReadWriteMany"]
    storage_class_name = var.deven_workspace_storage_class
    persistent_volume_source {
      host_path {
        path = var.deven_workspace_hostpath
        type = "Directory"
      }
    }
  }
}

