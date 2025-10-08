package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/postgres-init:rolling")
	testhelpers.TestFileExists(t, ctx, image, "/usr/libexec/postgresql17/psql", nil)
}
