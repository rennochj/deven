locals {
  public_key = file(pathexpand(var.public_key_file))
}

provider "aws" {

  shared_config_files      = [pathexpand(var.aws_config)]
  shared_credentials_files = [pathexpand(var.aws_credentials)]
  profile                  = var.aws_profile
  region                   = var.aws_region

}

resource "aws_ecs_cluster" "deven_cluster" {
  name = "deven-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


