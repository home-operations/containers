package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/k8s-sidecar:rolling")
	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "python", "-u", "-m", "sidecar", "--help")
}
