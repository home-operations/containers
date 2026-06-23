package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/kopia:rolling")
	helpers.RequireCommandSucceeds(t, image, nil, "/usr/local/bin/kopia", "--version")
}
