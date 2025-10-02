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
		image = "ghcr.io/home-operations/smartctl-exporter:rolling"
	}

	app, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithExposedPorts("9633/tcp"),
		testcontainers.WithWaitStrategy(
			wait.ForListeningPort("9633/tcp"),
		),
	)
	testcontainers.CleanupContainer(t, app)
	require.NoError(t, err)
}
