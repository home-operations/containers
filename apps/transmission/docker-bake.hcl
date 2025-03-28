target "docker-metadata-action" {}

variable "VERSION" {
  // NOTE: When updating the alpine version, remember to update the Dockerfile
  // file with the new alpine version number in the base image.
  // renovate: datasource=repology depName=alpine_3_21/transmission-daemon versioning=loose
  default = "4.0.6-r0"
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
    "org.opencontainers.image.source" = "https://github.com/transmission/transmission"
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
