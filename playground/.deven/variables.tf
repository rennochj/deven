variable "current-user" {
  description = "Current user"
  type        = string
}

variable "ssh-port" {
  description = "SSH port"
  type        = number
  default     = 32222
}

variable "workspace-git-repo" {
  description = "URL for GitHub repo"
  type        = string
  default     = ""
}

variable "docker-host" {
  description = "Docker Host URL"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "docker-image" {
  description = "Prevent destruction of workspace volume"
  type        = string
  default     = "ghcr.io/rennochj/deven-ubuntu-base:latest"
}

variable "docker-config-file" {
  description = "Location of Docker configuration file"
  type        = string
  default     = "~/.docker/config.json"
}

variable "public-key-file" {
  description = "Location of the public key file for SSH known_hosts"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "deven-workspace-postfix" {
  description = "Postfix of the workspace volume"
  type        = string
  default     = "-playgroud-workspace"
}
