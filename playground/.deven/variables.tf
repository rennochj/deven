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
  default = "localhost"
}

variable "docker-ssh-opts" {
  description = "The docker SSH options"
  type        = list(string)
  default     = []
}

variable "deven-image" {
  description = "The URL for the deven Docker image"
  type        = string
  default     = "ghcr.io/rennochj/deven-amazon-base:latest"
}

variable "deven-instance-name" {
  description = "The name of the deven Docker container"
  type        = string
  default     = "deven"
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
