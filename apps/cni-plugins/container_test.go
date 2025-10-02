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
		image = "ghcr.io/home-operations/cni-plugins:rolling"
	}

	app, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithCmdArgs("test", "-d", "/plugins/macvlan"),
	)
	testcontainers.CleanupContainer(t, app)
	require.NoError(t, err)
}
