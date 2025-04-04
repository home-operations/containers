target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.servarr depName=readarr versioning=loose
  default = "0.4.13.2760"
}

variable "SOURCE" {
  default = "https://github.com/Readarr/Readarr"
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
