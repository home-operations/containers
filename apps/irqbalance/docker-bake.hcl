target "docker-metadata-action" {}

variable "APP" {
  default = "irqbalance"
}

variable "VERSION" {
  // renovate: datasource=repology depName=alpine_3_24/irqbalance versioning=apk
  default = "1.9.5-r0"
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
