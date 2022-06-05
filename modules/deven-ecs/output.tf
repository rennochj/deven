
output "deven_security_group" {
  value = aws_security_group.deven_ecs_sg.id
}

output "deven_instance" {

  value = aws_ecs_service.deven_service.network_configuration[0].assign_public_ip ? local.public_ip : local.private_ip

  depends_on = [
    aws_ecs_service.deven_service
  ]

}

