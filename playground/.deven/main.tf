
locals {

  deven-workspace = "${var.current-user}"

}

module "deven-docker" {

  source = "../../modules/deven-docker"

  docker-host        = var.docker-host
  deven-image        = var.docker-image
  docker-config-file = var.docker-config-file
  public-key-file    = var.public-key-file
  deven-workspace    = local.deven-workspace
  workspace-git-repo = var.workspace-git-repo
  ssh-port           = var.ssh-port

}
