package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/k8s-sidecar:rolling")
	helpers.RequireCommandSucceeds(t, image, nil, "python", "-u", "-m", "sidecar", "--help")
}
