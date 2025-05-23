target "docker-metadata-action" {}

variable "APP" {
  default = "k8s-sidecar"
}

variable "VERSION" {
  // renovate: datasource=docker depName=ghcr.io/kiwigrid/k8s-sidecar
  default = "1.30.3"
}

variable "SOURCE" {
  default = "https://github.com/kiwigrid/k8s-sidecar"
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
