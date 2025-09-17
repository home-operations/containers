target "docker-metadata-action" {}

variable "APP" {
  default = "pyload-ng"
}

variable "VERSION" {
  // renovate: datasource=pypi depName=pyload-ng
  default = "0.5.0b3.dev93"
}

variable "SOURCE" {
  default = "https://github.com/pyload/pyload"
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
