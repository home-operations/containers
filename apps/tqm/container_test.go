package main

import (
	"context"
	"os"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/testcontainers/testcontainers-go"
)

func Test(t *testing.T) {
	ctx := context.Background()

	image := os.Getenv("TEST_IMAGE")
	if image == "" {
		image = "ghcr.io/home-operations/tqm:rolling"
	}

	app, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithCmdArgs("test", "-f", "/app/bin/tqm"),
	)
	testcontainers.CleanupContainer(t, app)
	require.NoError(t, err)
}
