target "docker-metadata-action" {}

variable "APP" {
  default = "postgres-init"
}

variable "VERSION" {
  // renovate: datasource=docker depName=docker.io/library/postgres
  default = "18.0-alpine3.22"
}

variable "SOURCE" {
  default = "https://github.com/postgres/postgres"
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
