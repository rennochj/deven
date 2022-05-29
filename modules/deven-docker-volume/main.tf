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

resource "docker_image" "alpine_git" {
  name         = var.initialization_container
  keep_locally = false
}

resource "docker_volume" "deven_workspace" {
  name = var.deven_workspace
}

resource "docker_container" "initialize_workspace" {

  count = "${var.workspace_git_repo}" != "" ? 1 : 0

  image = docker_image.alpine_git.name
  name  = "deven_initialize_workspace"

  volumes {
    volume_name    = docker_volume.deven_workspace.name
    container_path = "/workspace"
    read_only      = false
  }

  command = [
    "bash",
    "-c",
    "if [ -n '${var.workspace_git_repo}' ]; then cd /workspace ; chown deven -R /workspace ; git clone '${var.workspace_git_repo}' ; fi"
  ]

  tty      = true
  must_run = false
  rm       = true

}
