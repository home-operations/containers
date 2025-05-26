target "docker-metadata-action" {}

variable "APP" {
  default = "radarr"
}

variable "VERSION" {
  // renovate: datasource=custom.servarr-develop depName=radarr versioning=loose
  default = "5.24.1.10017"
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
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
