package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/pyload-ng:rolling")
	testhelpers.RequireHTTPEndpoint(t, image, testhelpers.HTTPTestConfig{Port: "8000"}, nil)
}
