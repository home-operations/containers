package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/tududi:rolling")
	testhelpers.TestHTTPEndpoint(t, ctx, image, testhelpers.HTTPTestConfig{
		Port:       "3002",
		Path:       "/api/health",
		StatusCode: 200,
	}, &testhelpers.ContainerConfig{
		Env: map[string]string{
			"TUDUDI_USER_EMAIL":     "test@example.com",
			"TUDUDI_USER_PASSWORD":  "testpassword123",
			"TUDUDI_SESSION_SECRET": "test-session-secret-32chars!!",
		},
	})
}
