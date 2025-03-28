target "docker-metadata-action" {}

variable "VERSION" {
  // renovate: datasource=custom.plex depName=plex versioning=loose
  default = "1.41.5.9522-a96edc606"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
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
