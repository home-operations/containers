target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.fileflows depName=fileflows versioning=loose
  default = "25.4.6.5339"
}

variable "SOURCE" {
  default = "https://github.com/revenz/fileflows"
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
