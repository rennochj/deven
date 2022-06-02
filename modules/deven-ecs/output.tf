output "deven_instance" {
  value = aws_lb.deven_nlb.dns_name
}

output "deven_service" {
  value = aws_ecs_service.deven_service
}
