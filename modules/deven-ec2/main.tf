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

resource "aws_network_interface" "deven_network_interface" {
  subnet_id = var.aws_subnet

  tags = {
    Name = "deven_network_interface"
  }

  security_groups = [
    aws_security_group.deven_sg.id
  ]

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

resource "aws_instance" "deven" {

  ami           = data.aws_ami.deven_ami.id
  instance_type = var.deven_instance_type

  tags = {
    Name = var.deven_instance_name
  }

  subnet_id = var.aws_subnet
  vpc_security_group_ids = [aws_security_group.deven_sg.id]

  key_name = aws_key_pair.deven_key.key_name

  user_data = <<EOF
    #!/bin/bash
    mkdir /workspace
    mkfs -t xfs /dev/sdb
    mount /dev/sdb /workspace
    echo '/dev/sdb /workspace xfs defaults,nofail 0 2' >> /etc/fstab
    chown ec2-user /workspace
    ${var.deven_instance_user_data}
  EOF

}

resource "aws_volume_attachment" "mountvolumetoec2" {
  device_name = "/dev/sdb"
  instance_id = aws_instance.deven.id
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
    InstanceId = aws_instance.deven.id
  }
  alarm_actions = [
    "arn:aws:automate:us-west-2:ec2:terminate"
  ]

}



