package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/kata-guest-kernel:rolling")
	helpers.RequireFileExists(t, image, "/artifacts/vmlinux-nested")
	helpers.RequireFileExists(t, image, "/artifacts/configuration-qemu.toml")
}
