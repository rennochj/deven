locals {
  docker_host = var.docker_host == "localhost" ? "unix:///var/run/docker.sock" : "ssh://${var.docker_username}@${var.docker_host}"
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

provider "docker" {

  host     = local.docker_host
  ssh_opts = var.docker_ssh_opts

  registry_auth {
    address     = "ghcr.io"
    config_file = pathexpand(var.docker_config_file)
  }

}

resource "docker_volume" "deven_workspace" {
  name = var.deven_workspace
}

