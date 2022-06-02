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

variable "public_key_file" {
  description = "The public key file location for access to the Deven instance"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "deven_ami_names" {
  description = "The AMI names for the deven instance"
  type        = list(string)
  default     = ["Amazon Linux 2"]
}

variable "deven_ami_owners" {
  description = "The AMI owner for the deven instance"
  type        = list(string)
  default     = ["823765613917"]
}

variable "deven_instance_type" {
  description = "The the instance type "
  type        = string
  default     = "t3.large"
}

variable "aws_vpc" {
  description = "The vpc for the deven instance"
  type        = string
}

variable "aws_subnet" {
  description = "The subnet for the deven instance"
  type        = string
}

variable "deven_workspace_volume_id" {
  description = "The workspace volume instance"
  type        = string
}

variable "deven_instance_name" {
  description = "The name of the deven instance"
  type        = string
  default     = "deven"
}

variable "deven_instance_user_data" {
  description = "Command to be executed following instantiation"
  type        = string
  default     = ""
}

variable "deven_idle_eval_periods" {
  description = "Number of idle evaluation periods "
  type        = number
  default     = 3
}

variable "deven_idle_period" {
  description = "The idle time period (seconds)"
  type        = number
  default     = 600
}

variable "deven_idle_cpu_threshhold" {
  description = "The CPU threshold to measure idle periods"
  type        = string
  default     = 2
}


