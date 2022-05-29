# This file is generated from .deven-ec2/compute/main.tf.deven. All changes to this file may be overwritten. 

module "deven_ec2" {

  source = "/Users/rennochj/code/deven/modules/deven-ec2"

  # aws_config = "~/.aws/config"
  # aws_credentials = "~/.aws/credentials"
  # aws_profile = "default"
  # aws_region = "us-west-2"
  aws_subnet = "subnet-0061fca622534b107"
  aws_vpc = "vpc-0c45ed9142d6190db"
  # deven_ami_names = ["Amazon Linux 2"]
  # deven_ami_owners = ["823765613917"]
  # deven_idle_cpu_threshhold = 2
  # deven_idle_eval_periods = 2
  # deven_idle_period = 60
  # deven_instance_name = "deven"
  # deven_instance_type = "t2.micro"
  # deven_instance_user_data = ""
  deven_workspace_volume_id = "vol-0c0ff904b9383ffc3"
  public_key_file = "/Users/rennochj/.ssh/deven-ec2-id_rsa.pub"

}

output "host" {
  value = module.deven_ec2.deven_instance
}

output "ssh_port" {
  value = 22
}

