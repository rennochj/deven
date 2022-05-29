locals {
  public_key                 = file(pathexpand(var.public_key_file))
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
  keep_locally = true
}

resource "docker_container" "deven" {

  image = docker_image.deven_image.name
  name  = var.deven_instance_name
  ports {
    internal = 22
    external = var.deven_ssh_port
  }

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
    DOCKER_HOST=${local.docker_host} docker exec ${var.deven_instance_name} bash -c "echo '${local.public_key}' > /home/deven/.ssh/authorized_keys"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      DOCKER_HOST=${local.docker_host} docker exec ${var.deven_instance_name} bash -c 'chown deven -R /workspace && chown deven -R /home/deven  && chown deven /var/run/docker.sock'
    EOT
  }

}


