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

variable "deven_workspace_hostpath" {
  description = "Workspace hostpath for deven envinronment"
  type        = string
}

variable "deven_workspace_capacity" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "10Gi"
}

variable "deven_workspace_storage_class" {
  description = "Workspace storage class for deven envinronment"
  type        = string
  default     = "hostpath"
}

variable "kubernetes_config" {
  description = "The path to the kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}
