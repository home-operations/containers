target "docker-metadata-action" {}

variable "APP" {
  default = "busybox"
}

variable "VERSION" {
  // renovate: datasource=docker depName=docker.io/library/busybox
  default = "1.37.0"
}

variable "SOURCE" {
  default = "https://www.busybox.net"
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
