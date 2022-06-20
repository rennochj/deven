
output "deven_private_ip" {
  value = aws_spot_instance_request.deven_spot.private_ip
}

output "deven_instance_id" {
  value = aws_spot_instance_request.deven_spot.spot_instance_id
}
