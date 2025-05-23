target "docker-metadata-action" {}

variable "APP" {
  default = "deluge"
}

variable "VERSION" {
  // renovate: datasource=repology depName=alpine_edge/deluge
  default = "2.2.0-r0"
}

variable "SOURCE" {
  default = "https://github.com/deluge-torrent/deluge"
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
