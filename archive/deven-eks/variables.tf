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

variable "registry_username" {
  description = "The username for to the ghcr.io package repository "
}

variable "registry_password" {
  description = "The password (PAT) for to the ghcr.io package repository "
}

variable "public_key_file" {
  description = "Provided public key for ssh login (authorized_keys)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "deven_image" {
  description = "The development image"
  type        = string
  default     = "ghcr.io/rennochj/deven-amazon-base:latest"
}

variable "deven_instance_name" {
  description = "Kubernetes pod name for deven container"
  type        = string
  default     = "deven_pod"
}

variable "deven_namespace" {
  description = "Kubernetes deven namespace "
  type        = string
  default     = "deven"
}

variable "deven_workspace_volume_id" {
  description = "Workspace name for deven envinronment"
  type        = string
}

variable "ssh_port" {
  description = "Exposed port for ssh"
  type        = number
  default     = 32222
}

variable "workspace_git_repo" {
  description = "the URL for the git repo for the workspace"
  type        = string
  default     = ""
}

variable "kubernetes_config" {
  description = "The path to the kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}
