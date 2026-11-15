package main

import (
	"path"
	"testing"

	"github.com/stretchr/testify/require"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/vchord:rolling")

	var majors []string
	for _, f := range helpers.ListFiles(t, image, "/usr/lib/postgresql") {
		if path.Base(f) == "vchord.so" {
			majors = append(majors, path.Base(path.Dir(path.Dir(f))))
		}
	}
	require.NotEmpty(t, majors, "image should ship vchord.so for at least one PostgreSQL major")

	for _, major := range majors {
		t.Run("pg"+major, func(t *testing.T) {
			helpers.RequireFileExists(t, image, path.Join("/usr/share/postgresql", major, "extension/vchord.control"))
		})
	}
}
