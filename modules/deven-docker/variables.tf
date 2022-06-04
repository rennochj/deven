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

variable "deven_image" {
  description = "The development image"
  type        = string
  default     = "ghcr.io/rennochj/deven-amazon-base:latest"
}

variable "deven_instance_name" {
  description = "The name of the deven Docker container"
  type        = string
  default     = "deven"
}

variable "docker_config_file" {
  description = "Location of the Docker configuration file"
  type        = string
  default     = "~/.docker/config.json"
}

variable "private_key_file" {
  description = "Provided private key for ssh login (authorized_keys)"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "deven_workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven_workspace"
}

variable "deven_ssh_port" {
  description = "Exposed port for ssh"
  type        = number
  default     = 2222
}

variable "initiatization_commands" {
  description = "Initialization commands to execute after instantiations"
  type        = list(string)
  default     = []
}