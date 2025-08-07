target "docker-metadata-action" {}

variable "APP" {
  default = "bitwarden-cli"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=bitwarden/clients versioning=regex:^cli-v(?<version>.*)$
  default = "2025.7.0"
}

variable "SOURCE" {
  default = "https://github.com/bitwarden/clients"
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
