target "docker-metadata-action" {}

variable "APP" {
  default = "vchord"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=pgsty/vchord
  default = "1.3.0"
}

variable "SOURCE" {
  default = "https://github.com/pgsty/vchord"
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
