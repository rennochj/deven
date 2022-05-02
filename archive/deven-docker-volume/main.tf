
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
  }
}

provider "docker" {

  host     = var.docker-host
  ssh_opts = var.docker-ssh-opts

  registry_auth {
    address     = "ghcr.io"
    config_file = pathexpand(var.docker-config-file)
  }

}

resource "docker_image" "workspace-git" {
  name         = "ghcr.io/rennochj/deven-alpine-base:latest"
  # name         = alpine/git
  keep_locally = false
}

resource "docker_volume" "deven-workspace" {
  name = var.deven-workspace

  lifecycle {
      prevent_destroy = true
  }

}

resource "docker_container" "initialize-workspace" {
  
  image = docker_image.workspace-git.name
  name  = "deven-initialize-workspace"
  tty = true
  must_run = false
  stdin_open = true
  # rm = true

  volumes {
    volume_name    = docker_volume.deven-workspace.name
    container_path = "/workspace"
    read_only      = false
  }

  command = [
    "ash", 
    "-c",
    "touch /workspace/hello"
    # "if [ -n '${var.workspace-git-repo}' ] ; then git clone '${var.workspace-git-repo}' /workspace/${var.workspace-git-repo-location}; else; echo 'not loaded'; fi"
    # "if [ -n 'https://github.com/rennochj/deven.git' ] && [ ! -d '/workspace/code' ] ; then git clone 'https://github.com/rennochj/deven.git' /workspace/code; fi"
    # "if [ -n '' ] && [ ! -d '' ] ; then git clone '' /workspace/code; fi"
  ]

}
