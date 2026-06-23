package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/tududi:rolling")
	helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{
		Port: "3002",
		Path: "/api/health",
	}, &helpers.ContainerConfig{
		Env: map[string]string{
			"TUDUDI_USER_EMAIL":     "test@example.com",
			"TUDUDI_USER_PASSWORD":  "testpassword123",
			"TUDUDI_SESSION_SECRET": "test-session-secret-32chars!!",
		},
	})
}
