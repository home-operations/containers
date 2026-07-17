package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/thelounge:rolling")
	helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{
		Port: "9000",
	}, &helpers.ContainerConfig{
		Env: map[string]string{
			"THELOUNGE_USER":     "test",
			"THELOUNGE_PASSWORD": "testpassword123",
		},
	})
}
