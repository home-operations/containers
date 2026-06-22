package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/kopia:rolling")
	testhelpers.RequireCommandSucceeds(t, image, nil, "/usr/local/bin/kopia", "--version")
}
