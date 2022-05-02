variable "current-user" {
  description = "Current user"
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
