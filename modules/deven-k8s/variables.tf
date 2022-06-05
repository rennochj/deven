
variable "registry_username" {
  description = "The username for to the ghcr.io package repository "
}

variable "registry_password" {
  description = "The password (PAT) for to the ghcr.io package repository "
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
  description = "Kubernetes pod name for deven container"
  type        = string
  default     = "deven_pod"
}

variable "deven_namespace" {
  description = "Kubernetes deven namespace "
  type        = string
  default     = "deven-ns"
}

variable "deven_workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven_workspace"
}

variable "deven_workspace_capacity" {
  description = "Workspace capacity for deven envinronment"
  type        = string
  default     = "10Gi"
}

variable "deven_ssh_port" {
  description = "Exposed port for ssh"
  type        = number
  default     = 2222
}

variable "kubernetes_config" {
  description = "The path to the kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

variable "initial_script" {
  description = "Initialization commands to execute after instantiations"
  type        = string
  default     = "initial-script"
}
