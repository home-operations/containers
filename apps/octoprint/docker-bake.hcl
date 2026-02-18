target "docker-metadata-action" {}

variable "APP" {
  default = "octoprint"
}

variable "VERSION" {
  // renovate: datasource=pypi depName=OctoPrint
  default = "1.11.7"
}

variable "SOURCE" {
  default = "https://github.com/OctoPrint/OctoPrint"
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
