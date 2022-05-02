
resource "docker_image" "alpine-git" {
  name         = "ghcr.io/rennochj/deven-alpine-base:latest"
  keep_locally = false
}

resource "docker_volume" "deven-workspace" {
  name = var.deven-workspace

  lifecycle {
      prevent_destroy = false
  }

}

resource "docker_container" "initialize-workspace" {
  image = docker_image.alpine-git.name
  name  = "deven-initialize-workspace"

  volumes {
    volume_name    = docker_volume.deven-workspace.name
    container_path = "/workspace"
    read_only      = false
  }

  command = [
    "bash", 
    "-c",
    "if [ -n '${var.workspace-git-repo}' ]; then cd /workspace && git clone '${var.workspace-git-repo}' && chown deven /workspace; fi"
  ]

  tty = true
  must_run = false

}