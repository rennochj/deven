# This file is generated from .deven-eks/storage/main.tf.deven. All changes to this file may be overwritten. 

module "deven_k8s_ebs" {

  source = "/Users/rennochj/code/deven/modules/deven-k8s-ebs"

  aws_availability_zone = "us-west-2a"
  # aws_config = "~/.aws/config"
  # aws_credentials = "~/.aws/credentials"
  # aws_profile = "default"
  # aws_region = "us-west-2"
  # deven_namespace = "deven-ns"
  deven_workspace     = "rennochj-deven-eks-workspace"
  # deven_workspace_capacity = "11"
  # deven_workspace_storage_class = "gp2"
  # ebs_type = "gp2"
  kubernetes_config = "~/.kube/deven-eks.config"

}

