target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.servarr depName=prowlarr versioning=loose
  default = "1.33.1.4997"
}

variable "SOURCE" {
  default = "https://github.com/Prowlarr/Prowlarr"
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
