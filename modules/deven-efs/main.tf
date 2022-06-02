
provider "aws" {

  shared_config_files      = [pathexpand(var.aws_config)]
  shared_credentials_files = [pathexpand(var.aws_credentials)]
  profile                  = var.aws_profile
  region                   = var.aws_region

}

resource "aws_efs_file_system" "deven_efs" {

  creation_token = "deven-efs-token"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  availability_zone_name = "${var.deven_availability_zone}"

  tags = {
    Name = "${var.deven_workspace}"
  }

}

