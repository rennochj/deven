# This file is generated from .deven-k8s/storage/main.tf.deven. All changes to this file may be overwritten. 

module "deven_k8s_hostpath" {

  source = "/Users/rennochj/code/deven/modules/deven-k8s-hostpath"

  #  deven_namespace = "deven-ns"
  deven_workspace     = "rennochj-deven-k8s-workspace"
  #  deven_workspace_capacity = "10Gi"
  deven_workspace_hostpath = "/Users/rennochj/code/deven/workspace"
  #  deven_workspace_storage_class = "hostpath"
  #  kubernetes_config = "~/.kube/config"

}

