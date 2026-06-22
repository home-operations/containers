package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/busybox:rolling")
	testhelpers.RequireCommandSucceeds(t, image, nil, "/bin/busybox", "--list")
}
