output "deven_instance" {
  value = aws_spot_instance_request.deven_spot.public_ip
}
