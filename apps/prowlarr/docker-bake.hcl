target "docker-metadata-action" {}

variable "APP" {
  default = "prowlarr"
}

variable "VERSION" {
  // renovate: datasource=custom.servarr-develop depName=prowlarr versioning=loose
  default = "1.36.2.5059"
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
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
