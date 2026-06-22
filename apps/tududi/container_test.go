package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/tududi:rolling")
	testhelpers.RequireHTTPEndpoint(t, image, testhelpers.HTTPTestConfig{
		Port: "3002",
		Path: "/api/health",
	}, &testhelpers.ContainerConfig{
		Env: map[string]string{
			"TUDUDI_USER_EMAIL":     "test@example.com",
			"TUDUDI_USER_PASSWORD":  "testpassword123",
			"TUDUDI_SESSION_SECRET": "test-session-secret-32chars!!",
		},
	})
}
