package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/plex-next:rolling")
	helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{
		Port: "32400",
		Path: "/web/index.html",
	}, nil)
}
