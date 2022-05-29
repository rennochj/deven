
terraform {
  required_providers {
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

resource "aws_ebs_volume" "deven_volume_ebs" {
  availability_zone = var.aws_availability_zone
  type              = var.ebs_type
  size              = var.deven_workspace_capacity
  encrypted         = true
  tags = {
    Name = "${var.deven_workspace}"
  }
}
