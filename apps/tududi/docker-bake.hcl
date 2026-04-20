target "docker-metadata-action" {}

variable "APP" {
  default = "tududi"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=chrisvel/tududi
  default = "v1.1.0-dev.14"
}

variable "SOURCE" {
  default = "https://github.com/chrisvel/tududi"
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
