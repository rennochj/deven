
locals {

  deven-workspace = "${var.current-user}${var.deven-workspace-postfix}"
  deven-home = "${var.current-user}${var.deven-workspace-postfix}"

}

module "deven-docker" {

  source = "../../modules/deven-docker"

  docker-host          = var.docker-host
  docker-username      = var.current-user
  deven-image   = var.deven-image
  deven-instance-name = var.deven-instance-name
  docker-config-file   = var.docker-config-file
  public-key-file      = var.public-key-file
  deven-workspace      = local.deven-workspace
  workspace-git-repo   = var.workspace-git-repo
  ssh-port             = var.ssh-port

}
