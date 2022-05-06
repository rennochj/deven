
output "container" {
  value = docker_container.deven
}

output "docker-host" {
  value = var.docker-host
}

output "ssh-port" {
  value = var.ssh-port
}