module "deven-docker-instance" {

  source = "../deven-docker-base"

  docker-host        = "unix:///var/run/docker.sock"
  deven-image        = var.deven-image
  docker-config-file = var.docker-config-file
  public-key-file    = var.public-key-file
  deven-workspace    = var.deven-workspace
  ssh-port           = var.ssh-port

}