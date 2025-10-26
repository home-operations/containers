target "docker-metadata-action" {}

variable "APP" {
  default = "stash"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=stashapp/stash
  default = "v0.28.1"
}

variable "SOURCE" {
  default = "https://github.com/stashapp/stash"
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
