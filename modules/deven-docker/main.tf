locals {
  public_key                 = file(pathexpand("${var.private_key_file}.pub"))
  private_key                = file(pathexpand(var.private_key_file))
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

resource "docker_image" "deven_image" {
  name         = var.deven_image
  keep_locally = false
  force_remove = true
}

resource "docker_container" "deven" {

  image = docker_image.deven_image.name
  name  = var.deven_instance_name
  ports {
    internal = 22
    external = var.deven_ssh_port
  }

  env = [
    "SSH_PUBLIC_KEY=${local.public_key}"
  ]

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  volumes {
    volume_name    = var.deven_workspace
    container_path = "/workspace"
    read_only      = false
  }

  provisioner "local-exec" {
    command = <<-EOT
    DOCKER_HOST=${local.docker_host} docker exec ${var.deven_instance_name} bash -c "deven-initialize"
    EOT
  }

}

resource "null_resource" "remote_execute" {

  count = length(var.initiatization_commands) > 0 ? 1 : 0

  depends_on = [docker_container.deven]

  provisioner "remote-exec" {
    
    connection {

      type = "ssh"
      user = "deven"
      private_key = local.private_key
      host = var.docker_host
      port = var.deven_ssh_port
    
    }
    
    inline = var.initiatization_commands

  }

}
