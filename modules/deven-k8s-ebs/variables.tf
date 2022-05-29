variable "kubernetes_config" {
  description = "The path to the kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

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

variable "aws_availability_zone" {
  description = "The AWS availability zone"
  type        = string
}

variable "deven_workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven-workspace"
}

variable "deven_namespace" {
  description = "Kubernetes deven namespace "
  type        = string
  default     = "deven-ns"
}

variable "deven_workspace_storage_class" {
  description = "Workspace storage class for deven envinronment"
  type        = string
  default     = "gp2"
}

variable "ebs_type" {
  description = "Type of ebs storage"
  type        = string
  default     = "gp2"
}

variable "deven_workspace_capacity" {
  description = "Workspace capacity for deven envinronment"
  type        = string
  default     = "11"
}
