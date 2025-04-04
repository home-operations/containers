target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=containernetworking/plugins
  default = "v1.6.2"
}

variable "SOURCE" {
  default = "https://github.com/containernetworking/plugins"
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
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
