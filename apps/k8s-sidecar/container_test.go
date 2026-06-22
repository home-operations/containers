package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/k8s-sidecar:rolling")
	testhelpers.RequireCommandSucceeds(t, image, nil, "python", "-u", "-m", "sidecar", "--help")
}
