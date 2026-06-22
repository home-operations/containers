package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/deluge:rolling")
	testhelpers.RequireHTTPEndpoint(t, image, testhelpers.HTTPTestConfig{
		Port: "8112",
	}, &testhelpers.ContainerConfig{
		Env: map[string]string{
			"DELUGE_BIN": "deluge-web",
		},
	})
}
