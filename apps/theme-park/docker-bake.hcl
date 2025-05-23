target "docker-metadata-action" {}

variable "APP" {
  default = "theme-park"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=themepark-dev/theme.park
  default = "1.20.1"
}

variable "SOURCE" {
  default = "https://github.com/themepark-dev/theme.park"
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
