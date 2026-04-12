target "docker-metadata-action" {}

variable "APP" {
  default = "resticprofile"
}

variable "VERSION" {
  // renovate: datasource=docker depName=docker.io/creativeprojects/resticprofile
  default = "0.33.0"
}

variable "SOURCE" {
  default = "https://github.com/creativeprojects/resticprofile/"
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
