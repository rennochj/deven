locals {
  public-key = file(pathexpand(var.public-key-file))
  docker-host = var.docker-host == "localhost" ? "unix:///var/run/docker.sock" : "ssh://${var.docker-username}@${var.docker-host}"
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

  host     = local.docker-host
  ssh_opts = var.docker-ssh-opts

  registry_auth {
    address     = "ghcr.io"
    config_file = pathexpand(var.docker-config-file)
  }

}

resource "docker_image" "deven-image" {
  name         = var.deven-image
  keep_locally = true
}

resource "docker_container" "deven" {

  image = docker_image.deven-image.name
  name  = var.deven-instance-name
  ports {
    internal = 22
    external = var.ssh-port
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  volumes {
    volume_name    = docker_volume.deven-workspace.name
    container_path = "/workspace"
    read_only      = false
  }

  provisioner "local-exec" {
    command = <<-EOT
    DOCKER_HOST=${local.docker-host} docker exec deven bash -c "echo '${local.public-key}' > /home/deven/.ssh/authorized_keys"
    EOT
  }

  provisioner "local-exec" {
    command = <<-EOT
      DOCKER_HOST=${local.docker-host} docker exec deven bash -c 'chown deven -R /workspace && chown deven -R /home/deven  && chown deven /var/run/docker.sock'
    EOT
  }

}


