target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.servarr depName=lidarr versioning=loose
  default = "2.11.2.4629"
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
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
