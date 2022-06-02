locals {
  public_key                 = file(pathexpand(var.public_key_file))
}

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

resource "aws_kms_key" "ghcr_repository_key" {
  description             = "GHCR repository key"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "ghcr_repository_key" {
  name          = "alias/ghcr-repository-key"
  target_key_id = aws_kms_key.ghcr_repository_key.key_id
}

resource "aws_secretsmanager_secret" "ghcr_repository_secret" {
  name       = "ghcr-secret-${random_string.random_suffix.result}"
  kms_key_id = aws_kms_key.ghcr_repository_key.key_id
}

resource "aws_secretsmanager_secret_version" "ghcr_repository_secret" {
  secret_id     = aws_secretsmanager_secret.ghcr_repository_secret.id
  secret_string = "{\"username\":\"${var.registry_username}\",\"password\":\"${var.registry_password}\"}"
}

resource "aws_security_group" "deven_ecs_sg" {
  name        = "deven_ecs_sg-${random_string.random_suffix.result}"
  description = "deven security group"
  vpc_id      = "${var.deven_vpc}"

  # To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_iam_role" "deven_ecs_execuition_role" {
  name = "devenECSTaskExecutionRole-${random_string.random_suffix.result}"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ecs-tasks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "initial_attach" {
  role       = aws_iam_role.deven_ecs_execuition_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ghcr_repository_secret_policy_document" {
  statement {
    actions = [
      "kms:Decrypt",
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_kms_key.ghcr_repository_key.arn,
      aws_secretsmanager_secret.ghcr_repository_secret.arn
    ]
  }
}

resource "aws_iam_policy" "ghcr_repository_policy" {
  name   = "ghcr-repository-policy-document-${random_string.random_suffix.result}"
  policy = data.aws_iam_policy_document.ghcr_repository_secret_policy_document.json
}

resource "aws_iam_role_policy_attachment" "deven_repository_permissions" {
  role       = aws_iam_role.deven_ecs_execuition_role.name
  policy_arn = aws_iam_policy.ghcr_repository_policy.arn
}

resource "aws_efs_mount_target" "deven_mount" {
  file_system_id = "${var.deven_efs_id}"
  subnet_id      = "${var.deven_subnet}"
  security_groups = [aws_security_group.deven_ecs_sg.id]
}

resource "aws_ecs_task_definition" "deven_task" {
  family                   = "${var.deven_instance_name}-task-${random_string.random_suffix.result}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.deven_ecs_execuition_role.arn
  cpu                      = 512
  memory                   = 1024

  volume {
    name = "deven-workspace"

    efs_volume_configuration {
      file_system_id          = "${var.deven_efs_id}"
      root_directory          = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name  = "${var.deven_instance_name}"
      image = "${var.deven_image}"
      repositoryCredentials = {
        credentialsParameter = aws_secretsmanager_secret.ghcr_repository_secret.arn
      }
      environment = [
        {
          "name": "SSH_PUBLIC_KEY",
          "value": "${local.public_key}"
        }
      ]
      command = ["/bin/bash", "-c", "echo $SSH_PUBLIC_KEY > /home/deven/.ssh/authorized_keys && chown deven -R /home/deven && /usr/sbin/sshd -D && chown -R /workspace"]
      essential = true
      mountPoints = [
        {
          "sourceVolume" = "deven-workspace",
          "containerPath" = "/workspace",
          "readOnly" = false
        }
      ]
      portMappings = [
        {
          "containerPort" = 22
          "hostPort"      = 22
        }
      ]
    }
  ])
}

 resource "aws_lb" "deven_nlb" {
  name               = "${var.deven_instance_name}-nlb"
  internal           = false
  load_balancer_type = "network"

  enable_deletion_protection = false
  subnets         = ["${var.deven_subnet}"]
}

resource "aws_lb_target_group" "deven_load_balancer" {
  name        = "${var.deven_instance_name}-tg"
  port        = 22
  protocol    = "TCP_UDP"
  target_type = "ip"
  vpc_id      = "${var.deven_vpc}"
}

resource "aws_lb_listener" "deven_lb_listener" {
  load_balancer_arn = aws_lb.deven_nlb.arn
  port              = 22
  protocol          = "TCP_UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.deven_load_balancer.arn
  }
}

resource "aws_ecs_service" "deven_service" {
  name            = "deven-service-${random_string.random_suffix.result}"
  cluster         = "${var.deven_ecs_cluster}"
  task_definition = aws_ecs_task_definition.deven_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  scheduling_strategy  = "REPLICA"

  load_balancer {
    target_group_arn = aws_lb_target_group.deven_load_balancer.arn
    container_name   = "${var.deven_instance_name}"
    container_port   = 22
  }

  network_configuration {
    subnets         = ["${var.deven_subnet}"]
    assign_public_ip = true
    security_groups = [aws_security_group.deven_ecs_sg.id]
  }

}

