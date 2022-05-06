output "ssh-port" {
  value = module.deven-docker.ssh-port
}

output "docker-host" {
  value = module.deven-docker.docker-host
}

output "deven-container-name" {
  value = var.deven-instance-name
}

