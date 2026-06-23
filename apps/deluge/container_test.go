package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/deluge:rolling")
	helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{
		Port: "8112",
	}, &helpers.ContainerConfig{
		Env: map[string]string{
			"DELUGE_BIN": "deluge-web",
		},
	})
}
