target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.servarr depName=radarr versioning=loose
  default = "5.22.3.9889"
}

variable "SOURCE" {
  default = "https://github.com/Radarr/Radarr"
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
