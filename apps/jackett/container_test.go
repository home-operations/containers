package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/jackett:rolling")
	testhelpers.RequireHTTPEndpoint(t, image, testhelpers.HTTPTestConfig{
		Port:       "9117",
		StatusCode: 400,
	}, nil)
}
