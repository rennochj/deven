# This file is generated from ./.deven/compute/main.tf.deven. All changes to this file may be overwritten. 

module "deven_docker" {

  source = "/Users/rennochj/code/deven/modules/deven-docker"

  #  deven_image = "ghcr.io/rennochj/deven-amazon-base:latest"
  deven_instance_name = "deven-docker"
  deven_ssh_port = 2222
  deven_workspace     = "rennochj-deven-docker-workspace"
  #  docker_config_file = "~/.docker/config.json"
  #  docker_host = "localhost"
  #  docker_ssh_opts = []
  #  docker_username = null
  public_key_file     = "/Users/rennochj/.ssh/deven-docker-id_rsa.pub"
  #  workspace_git_repo = ""

}

output "host" {
  value = module.deven_docker.host
}

output "ssh_port" {
  value = module.deven_docker.ssh_port
}

