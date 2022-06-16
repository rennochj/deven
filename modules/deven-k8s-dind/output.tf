
# output "host" {
#   value = regex("(?:server:\\s*https:\\/\\/)(.*):\\d+", file(pathexpand(var.kubernetes_config)))[0]
# }

output "host" {
  value = "localhost"
}