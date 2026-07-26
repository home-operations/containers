target "docker-metadata-action" {}

variable "APP" {
  default = "kata-guest-kernel"
}

// Must track the Kata release shipped by the siderolabs/kata-containers Talos
// extension (KATA_CONTAINERS_VERSION in its vars.yaml), NOT the latest Kata
// release. The extension supplies the shim, QEMU and guest image that consume
// this kernel and its generated configuration-qemu.toml, so a skew pairs them
// with a mismatched guest and a config the on-node shim did not ship with.
//
// Deliberately not renovate-annotated: Kata 4.0.0 is released while the
// extension is still on 3.32.0, and an automatic bump would silently break
// nested KVM on every node.
variable "VERSION" {
  default = "3.32.0"
}

variable "SOURCE" {
  default = "https://github.com/kata-containers/kata-containers"
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

// KVM host support is x86-only here: nested KVM on arm64 additionally needs the
// VMM to emulate EL2 (`-M virt,virtualization=on`), which Kata does not configure.
target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64"
  ]
}
