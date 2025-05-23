target "docker-metadata-action" {}

variable "APP" {
  default = "actions-runner"
}

variable "VERSION" {
  // renovate: datasource=docker depName=ghcr.io/actions/actions-runner
  default = "2.324.0"
}

variable "SOURCE" {
  default = "https://github.com/actions/runner"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
  labels = {
    "org.opencontainers.image.source" = "${SOURCE}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
