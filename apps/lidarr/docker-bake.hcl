target "docker-metadata-action" {}

variable "APP" {
  default = "lidarr"
}

variable "VERSION" {
  // renovate: datasource=custom.servarr-develop depName=lidarr versioning=loose
  default = "2.12.1.4636"
}

variable "SOURCE" {
  default = "https://github.com/Lidarr/Lidarr"
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
