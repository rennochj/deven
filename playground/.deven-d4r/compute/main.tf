# This file is generated from .deven-d4r/compute/main.tf.deven. All changes to this file may be overwritten. 

module "deven_docker" {

  source = "/Users/rennochj/code/deven/modules/deven-docker"

  #  deven_image = "ghcr.io/rennochj/deven-amazon-base:latest"
  deven_instance_name = "deven_docker_d4r"
  deven_ssh_port = 2222
  deven_workspace     = "rennochj-deven_docker_d4r-workspace"
  #  docker_config_file = "~/.docker/config.json"
  docker_host = "d4r"
  #  docker_ssh_opts = []
  docker_username = "rennochj"
  public_key_file     = "~/.ssh/deven_docker_d4r-id_rsa.pub"
  #  workspace_git_repo = ""

}

output "host" {
  value = module.deven_docker.host
}

output "ssh_port" {
  value = module.deven_docker.ssh_port
}

