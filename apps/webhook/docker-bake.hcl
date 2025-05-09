target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=github-releases depName=adnanh/webhook
  default = "2.8.2"
}

variable "SOURCE" {
  default = "https://github.com/adnanh/webhook"
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
