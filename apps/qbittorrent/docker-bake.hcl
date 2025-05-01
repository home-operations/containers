target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.qbittorrent depName=qbittorrent
  default = "5.1.0"
}

variable "SOURCE" {
  default = "https://github.com/qbittorrent/qBittorrent"
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
