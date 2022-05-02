variable "deven-image" {
  description = "The development image"
  type        = string
  default     = "ghcr.io/rennochj/deven-amazon-base:latest"
}

variable "docker-config-file" {
  description = "Location of the Docker configuration file"
  type        = string
  default     = "~/.docker/config.json"
}

variable "public-key-file" {
  description = "Provided public key for ssh login (authorized_keys)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "deven-workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven-workspace"
}

variable "ssh-port" {
  description = "Exposed port for ssh"
  type        = number
  default     = 2222
}