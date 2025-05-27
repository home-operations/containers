target "docker-metadata-action" {}

variable "APP" {
  default = "esphome"
}

variable "VERSION" {
  // renovate: datasource=pypi depName=esphome
  default = "2025.5.1"
}

variable "SOURCE" {
  default = "https://github.com/esphome/esphome"
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
