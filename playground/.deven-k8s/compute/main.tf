# This file is generated from .deven-k8s/compute/main.tf.deven. All changes to this file may be overwritten. 

module "deven_k8s" {

  source = "/Users/rennochj/code/deven/modules/deven-k8s"

  #  deven_image = "ghcr.io/rennochj/deven-amazon-base:latest"
  deven_instance_name = "deven-k8s"
  #  deven_namespace = "deven-ns"
  deven_ssh_port = 2222
  deven_workspace     = "rennochj-deven-k8s-workspace"
  #  deven_workspace_capacity = "10Gi"
  #  kubernetes_config = "~/.kube/config"
  public_key_file = "~/.ssh/deven-k8s-id_rsa.pub"
  registry_password = "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"
  registry_username = "rennochj"

}

output "ssh_port" {
  value = 2222
}

output "deven_instance_name" {
  value = "deven-k8s"
}

output "host" {
  value = module.deven_k8s.host
}

