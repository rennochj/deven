# This file is generated from .deven-k8s-remote/storage/main.tf.deven. All changes to this file may be overwritten. 

module "deven_k8s_hostpath" {

  source = "/Users/rennochj/code/deven/modules/deven-k8s-hostpath"

  #  deven_namespace = "deven-ns"
  deven_workspace     = "rennochj-deven-k8s-remote-workspace"
  #  deven_workspace_capacity = "10Gi"
  deven_workspace_hostpath = "/home/rennochj"
  deven_workspace_storage_class = "microk8s-hostpath"
  kubernetes_config = "~/.kube/k8s.config"

}

