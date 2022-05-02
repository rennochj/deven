variable "docker-host" {
  description = "The docker host"
  type        = string
}

variable "docker-ssh-opts" {
  description = "The docker SSH options"
  type        = list(string)
  default     = []
}

variable "deven-image" {
  description = "The development image"
  type        = string
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

variable "workspace-git-repo" {
  description = "URL for GitHub repo"
  type        = string
}
variable "workspace-git-repo-location" {
  description = "Location for GitHub repo"
  type        = string
  default     = ""
}

variable "prevent-workspace-destroy" {
  description = "Prevent destruction of workspace volume"
  type        = bool
  default     = true
}