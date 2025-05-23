target "docker-metadata-action" {}

variable "APP" {
  default = "nzbhydra2"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=theotherp/nzbhydra2
  default = "v7.13.0"
}

variable "SOURCE" {
  default = "https://github.com/theotherp/nzbhydra2"
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
