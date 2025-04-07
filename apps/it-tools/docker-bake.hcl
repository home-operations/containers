target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=CorentinTh/it-tools
  default = "v2024.10.22-7ca5933"
}

variable "SOURCE" {
  default = "https://github.com/CorentinTh/it-tools"
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
