# This file is generated from ./.deven/storage/main.tf.deven. All changes to this file may be overwritten. 

module "deven_docker_volume" {

  source = "/Users/rennochj/code/deven/modules/deven-docker-volume"

  deven_workspace     = "rennochj-deven-docker-workspace"
  #  docker_config_file = "~/.docker/config.json"
  #  docker_host = "localhost"
  #  docker_ssh_opts = []
  #  docker_username = null
  #  initialization_container = "ghcr.io/rennochj/deven-alpine-base:latest"
  workspace_git_repo = "https://github.com/rennochj/deven.git"

}

output "id" {
  value = module.deven_docker_volume.id
}

