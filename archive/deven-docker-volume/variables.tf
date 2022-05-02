variable "docker-host" {
  description = "The docker host"
  type        = string
}

variable "docker-ssh-opts" {
  description = "The docker SSH options"
  type        = list(string)
  default     = []
}

variable "docker-config-file" {
  description = "Location of the Docker configuration file"
  type        = string
  default     = "~/.docker/config.json"
}

variable "deven-workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven-workspace"
}

variable "workspace-git-repo" {
  description = "URL for GitHub repo"
  type        = string
  default     = ""
}

variable "workspace-git-repo-location" {
  description = "Location for GitHub repo"
  type        = string
  default     = "code"
}

variable "prevent-workspace-destroy" {
  description = "Prevent destruction of workspace volume"
  type        = bool
  default     = true
}
