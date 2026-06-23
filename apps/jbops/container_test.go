package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/jbops:rolling")
	helpers.RequireFileExists(t, image, "/app/fun/plexapi_haiku.py")
}
