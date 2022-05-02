
variable "registry_username" {
  description = "The username for to the ghcr.io package repository "
}

variable "registry_password" {
  description = "The password (PAT) for to the ghcr.io package repository "
}

variable "public-key-file" {
  description = "Provided public key for ssh login (authorized_keys)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "deven-image" {
  description = "The development image"
  type        = string
  default     = "ghcr.io/rennochj/deven-ubuntu-base:latest"
}

variable "deven-pod-name" {
  description = "Kubernetes pod name for deven container"
  type        = string
  default     = "deven-pod"
}

variable "deven-namespace" {
  description = "Kubernetes deven namespace "
  type        = string
  default     = "deven"
}

variable "deven-workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven-workspace"
}

variable "ssh-port" {
  description = "Exposed port for ssh"
  type        = number
  default     = 32222
}

variable "workspace-git-repo-url" {
  description = "the URL for the git repo for the workspace"
  type        = string
  default     = ""
}

