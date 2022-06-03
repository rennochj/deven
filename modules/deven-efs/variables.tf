variable "aws_config" {
  description = "location of the AWS configuration file"
  type        = string
  default     = "~/.aws/config"
}

variable "aws_credentials" {
  description = "location of the AWS credentials file"
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_profile" {
  description = "The default AWS profile"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "The default AWS region"
  type        = string
  default     = "us-west-2"
}

variable "deven_workspace" {
  description = "Workspace name for deven envinronment"
  type        = string
  default     = "deven-workspace"
}

variable "deven_availability_zone" {
  description = "Availability zone name for deven workspoace volume"
  type        = string
  default     = "us-west-2a"
}

variable "deven_subnet" {
  description = "The subnet for the deven instance"
  type        = string
}

variable "deven_vpc" {
  description = "The vpc for the deven instance"
  type        = string
}

