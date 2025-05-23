target "docker-metadata-action" {}

variable "APP" {
  default = "whisparr"
}

variable "VERSION" {
  // renovate: datasource=custom.servarr-nightly depName=whisparr versioning=loose
  default = "2.0.0.987"
}

variable "SOURCE" {
  default = "https://github.com/Whisparr/Whisparr"
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
