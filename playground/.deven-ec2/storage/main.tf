# This file is generated from .deven-ec2/storage/main.tf.deven. All changes to this file may be overwritten. 

module "deven_ec2_ebs" {

  source = "/Users/rennochj/code/deven/modules/deven-ec2-ebs"

  aws_availability_zone = "us-west-2a"
  # aws_config = "~/.aws/config"
  # aws_credentials = "~/.aws/credentials"
  # aws_profile = "default"
  # aws_region = "us-west-2"
  deven_workspace = "rennochj-deven-ec2-workspace"
  # deven_workspace_capacity = "10"
  # ebs_type = "gp2"

}

