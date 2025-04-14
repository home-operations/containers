target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=repology depName=alpine_edge/deluge
  default = "2.1.1-r10"
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
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
