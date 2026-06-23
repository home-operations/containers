package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/prowlarr:rolling")
	helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{Port: "9696"}, nil)
}
