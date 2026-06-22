package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/tqm:rolling")
	testhelpers.RequireCommandSucceeds(t, image, nil, "/app/bin/tqm", "version")
}
