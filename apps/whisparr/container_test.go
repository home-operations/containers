package main

import (
	"context"
	"os"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/wait"
)

func Test(t *testing.T) {
	ctx := context.Background()

	image := os.Getenv("TEST_IMAGE")
	if image == "" {
		image = "ghcr.io/home-operations/whisparr:rolling"
	}

	app, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithExposedPorts("6969/tcp"),
		testcontainers.WithWaitStrategy(
			wait.ForListeningPort("6969/tcp"),
			wait.ForHTTP("/").WithPort("6969/tcp").WithStatusCodeMatcher(func(status int) bool {
				return status == 200
			}),
		),
	)
	testcontainers.CleanupContainer(t, app)
	require.NoError(t, err)
}
