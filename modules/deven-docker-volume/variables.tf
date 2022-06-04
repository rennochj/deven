variable "docker_host" {
  description = "The docker host"
  type        = string
  default     = "localhost"
}

variable "docker_username" {
  description = "The username for the docker host "
  type        = string
  default     = null
}

variable "docker_ssh_opts" {
  description = "The docker SSH options"
  type        = list(string)
  default     = []
}

variable "docker_config_file" {
  description = "Location of the Docker configuration file"
  type        = string
  default     = "~/.docker/config.json"
}

variable "deven_workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven_workspace"
}

variable "initialization_container" {
  description = "Container for initializing the workspace."
  type        = string
  default     = "ghcr.io/rennochj/deven-alpine-base:latest"
}
