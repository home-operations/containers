package main

import (
	"fmt"
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/vchord:rolling")
	for _, pg := range []string{"14", "15", "16", "17", "18"} {
		t.Run("pg"+pg, func(t *testing.T) {
			helpers.RequireFileExists(t, image, fmt.Sprintf("/usr/lib/postgresql/%s/lib/vchord.so", pg))
			helpers.RequireFileExists(t, image, fmt.Sprintf("/usr/share/postgresql/%s/extension/vchord.control", pg))
		})
	}
}
