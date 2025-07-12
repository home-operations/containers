target "docker-metadata-action" {}

variable "APP" {
  default = "vintagestory"
}

variable "VERSION" {
  // renovate: datasource=custom.vintagestory depName=vintagestory
  default = "1.21.12"
}

variable "SOURCE" {
  default = "https://vintagestory.at/"
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
  ]
}
