target "docker-metadata-action" {}

variable "APP" {
  default = "home-assistant"
}

variable "VERSION" {
  // renovate: datasource=pypi depName=homeassistant
  default = "2025.5.3"
}

variable "SOURCE" {
  default = "https://github.com/home-assistant/core"
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
