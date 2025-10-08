package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/busybox:rolling")
	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "/bin/busybox", "--list")
}
