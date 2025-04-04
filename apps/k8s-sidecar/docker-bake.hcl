target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=docker depName=ghcr.io/kiwigrid/k8s-sidecar
  default = "1.30.3"
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
    "org.opencontainers.image.source" = "https://github.com/kiwigrid/k8s-sidecar"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
