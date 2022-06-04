
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

data "aws_ami" "deven_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = var.deven_ami_names
  }

  owners = var.deven_ami_owners

}

resource "aws_key_pair" "deven_key" {

  key_name   = "deven_key"
  public_key = file(pathexpand(var.public_key_file))

}

resource "aws_security_group" "deven_sg" {
  name        = "deven_sg"
  description = "deven security group"
  vpc_id      = var.aws_vpc

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
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

resource "aws_spot_instance_request" "deven_spot" {

  ami                  = data.aws_ami.deven_ami.id
  instance_type        = var.deven_instance_type
  # spot_price           = "0.1"
  instance_interruption_behavior = "terminate"
  spot_type            = "persistent"
  wait_for_fulfillment = true
  key_name             = aws_key_pair.deven_key.key_name

  tags = {
    Name = var.deven_instance_name
  }

  subnet_id = var.aws_subnet
  vpc_security_group_ids = [aws_security_group.deven_sg.id]

  user_data = <<EOF
    #!/bin/bash
    mkdir /workspace
    mount /dev/sdb /workspace
    echo '/dev/sdb /workspace xfs defaults,nofail 0 2' >> /etc/fstab
    chown ec2-user /workspace
    ${join("\n", var.initiatization_commands)}
  EOF

}

resource "aws_volume_attachment" "mountvolumetoec2" {
  device_name = "/dev/sdb"
  instance_id = aws_spot_instance_request.deven_spot.spot_instance_id
  volume_id   = var.deven_workspace_volume_id
  stop_instance_before_detaching = true
}

resource "aws_cloudwatch_metric_alarm" "deven_cpu_alarm" {
  alarm_name          = "deven_cpu_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.deven_idle_eval_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.deven_idle_period
  statistic           = "Average"
  threshold           = var.deven_idle_cpu_threshhold
  alarm_description   = "This metric monitors ec2 cpu utilization"
  dimensions = {
    InstanceId = aws_spot_instance_request.deven_spot.spot_instance_id
  }
  alarm_actions = [
    "arn:aws:automate:${var.aws_region}:ec2:terminate"
  ]

}
