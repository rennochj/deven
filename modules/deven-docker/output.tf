
output "container" {
  value = docker_container.deven
}

output "host" {
  value = var.docker-host
}
