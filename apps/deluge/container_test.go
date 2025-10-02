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
		image = "ghcr.io/home-operations/deluge:rolling"
	}

	app, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithExposedPorts("58846/tcp"),
		testcontainers.WithWaitStrategy(
			wait.ForListeningPort("58846/tcp"),
		),
	)
	testcontainers.CleanupContainer(t, app)
	require.NoError(t, err)
}
