package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/kopia:rolling")
	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "/usr/local/bin/kopia", "--version")
}
