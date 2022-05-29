
locals {
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
      version = "~> 4.0"
    }
  }
}

provider "aws" {

  shared_config_files      = [pathexpand(var.aws_config)]
  shared_credentials_files = [pathexpand(var.aws_credentials)]
  profile                  = var.aws_profile
  region                   = var.aws_region

}

provider "kubernetes" {
  config_path = local.kubernetes_config_expanded
}

resource "aws_ebs_volume" "deven_volume_ebs" {
  availability_zone = var.aws_availability_zone
  type              = var.ebs_type
  size              = var.deven_workspace_capacity
  encrypted         = true
  tags = {
    Name = "${var.deven_workspace}"
  }
}

resource "kubernetes_namespace" "deven" {
  metadata {
    name = var.deven_namespace
  }
}

resource "kubernetes_persistent_volume" "deven_workspace_pv" {

  metadata {
    name = "${var.deven_workspace}"
  }

  spec {
    capacity = {
      storage = "${var.deven_workspace_capacity}"
    }
    access_modes = ["ReadWriteMany"]
    storage_class_name = "${var.deven_workspace_storage_class}"
    persistent_volume_source {
      aws_elastic_block_store {
        fs_type = "xfs"
        read_only = false
        volume_id = aws_ebs_volume.deven_volume_ebs.id
      }
    }
  }
}

