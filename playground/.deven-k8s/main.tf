
locals {

  deven-workspace = "${var.current-user}${var.deven-workspace-postfix}"
  deven-home = "${var.current-user}${var.deven-workspace-postfix}"

}

module "deven-k8s" {

  source = "../../modules/deven-k8s"

  registry-username = var.registry-username
  registry-password = var.registry-password
  public-key-file = var.public-key-file
  deven-image = var.deven-image
  deven-instance-name = var.deven-instance-name
  deven-namespace = var.deven-namespace
  deven-workspace = local.deven-workspace
  kubernetes-cluster = var.kubernetes-cluster
  ssh-port = var.ssh-port
  workspace-git-repo = var.workspace-git-repo
  kubernetes-config = var.kubernetes-config

}



