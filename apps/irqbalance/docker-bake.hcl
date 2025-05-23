target "docker-metadata-action" {}

variable "APP" {
  default = "irqbalance"
}

variable "VERSION" {
  // renovate: datasource=repology depName=alpine_3_21/irqbalance
  default = "1.9.4-r1"
}

variable "SOURCE" {
  default = "https://github.com/irqbalance/irqbalance"
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
