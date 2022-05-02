
module "deven-docker-workspace" {

  source = "../../../modules/deven-docker-volume"

  docker-host = "unix:///var/run/docker.sock"
  docker-config-file = "~/.docker/config.json"
  deven-workspace = "${var.current-user}-playgroud-workspace"
  # workspace-git-repo = ""
  # workspace-git-repo-location = "code"
  workspace-git-repo = "https://github.com/rennochj/deven.git"
  workspace-git-repo-location = "code"
  # workspace-git-repo = "${var.workspace-git-repo}"
  # workspace-git-repo-location = "${var.workspace-git-repo-location}"
  prevent-workspace-destroy = false

}
