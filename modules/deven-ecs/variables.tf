variable "aws_config" {
  description = "location of the AWS configuration file"
  type        = string
  default     = "~/.aws/config"
}

variable "aws_credentials" {
  description = "location of the AWS credentials file"
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "The default AWS profile"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The default AWS region"
  type        = string
  default     = "us-west-2"
}

variable "private_key_file" {
  description = "Provided private key for ssh login (authorized_keys)"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "deven_image" {
  description = "The development image"
  type        = string
  default     = "ghcr.io/rennochj/deven-amazon-base:latest"
}

variable "deven_instance_name" {
  description = "The name of the deven Docker container"
  type        = string
  default     = "deven"
}

variable "deven_efs_id" {
  description = "The id of the deven efs drive"
  type        = string
}

variable "deven_vpc" {
  description = "The vpc for the deven instance"
  type        = string
}

variable "deven_subnet" {
  description = "The subnet for the deven instance"
  type        = string
}

variable "deven_ecs_cluster" {
  description = "The ecs cluster for the deven service / task"
  type        = string
}

variable "registry_username" {
  description = "The username for to the ghcr.io package repository "
}

variable "registry_password" {
  description = "The password (PAT) for to the ghcr.io package repository "
  sensitive   = true
}

variable "assign_public_ip" {
  description = "Assign public ip"
  sensitive   = false
}

variable "initial_script" {
  description = "Initialization commands to execute after instantiations"
  type        = string
  default     = "initial-script"
}
