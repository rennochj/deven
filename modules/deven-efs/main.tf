
provider "aws" {

  shared_config_files      = [pathexpand(var.aws_config)]
  shared_credentials_files = [pathexpand(var.aws_credentials)]
  profile                  = var.aws_profile
  region                   = var.aws_region

}

resource "random_string" "random_suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_security_group" "deven_efs_sg" {
  name        = "deven_efs_sg-${random_string.random_suffix.result}"
  description = "deven security group"
  vpc_id      = var.deven_vpc

  # To Allow EFS Access
  ingress {
    from_port   = 2049
    protocol    = "tcp"
    to_port     = 2049
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_file_system" "deven_efs" {

  creation_token = "deven-efs-token"

  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  availability_zone_name = var.deven_availability_zone

  tags = {
    Name = "${var.deven_workspace}"
  }

}

resource "aws_efs_mount_target" "deven_mount" {
  file_system_id  = aws_efs_file_system.deven_efs.id
  subnet_id       = var.deven_subnet
  security_groups = [aws_security_group.deven_efs_sg.id]
}

