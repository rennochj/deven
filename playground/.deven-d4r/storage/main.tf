# This file is generated from .deven-d4r/storage/main.tf.deven. All changes to this file may be overwritten. 

module "deven_docker_volume" {

  source = "/Users/rennochj/code/deven/modules/deven-docker-volume"

  deven_workspace     = "rennochj-deven_docker_d4r-workspace"
  #  docker_config_file = "~/.docker/config.json"
  docker_host = "d4r"
  #  docker_ssh_opts = []
  docker_username = "rennochj"
  #  initialization_container = "ghcr.io/rennochj/deven-alpine-base:latest"
  workspace_git_repo = "https://github.com/rennochj/deven.git"

}

output "id" {
  value = module.deven_docker_volume.id
}

