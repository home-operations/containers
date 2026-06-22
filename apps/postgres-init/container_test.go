package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/postgres-init:rolling")
	testhelpers.RequireFileExists(t, image, "/usr/local/bin/createdb")
	testhelpers.RequireFileExists(t, image, "/usr/local/bin/createuser")
	testhelpers.RequireFileExists(t, image, "/usr/local/bin/psql")
	testhelpers.RequireFileExists(t, image, "/usr/local/bin/pg_isready")
}
