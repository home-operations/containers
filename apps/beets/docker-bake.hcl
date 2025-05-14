target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=beetbox/beets
  default = "v2.3.1"
}

variable "SOURCE" {
  default = "https://github.com/beetbox/beets"
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
