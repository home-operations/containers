package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/jbops:rolling")
	testhelpers.RequireFileExists(t, image, "/app/fun/plexapi_haiku.py")
}
