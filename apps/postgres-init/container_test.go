package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/postgres-init:rolling")
	testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/createdb", nil)
	testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/createuser", nil)
	testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/psql", nil)
	testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/pg_isready", nil)
}
