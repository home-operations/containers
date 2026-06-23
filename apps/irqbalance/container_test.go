package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/irqbalance:rolling")
	helpers.RequireFileExists(t, image, "/usr/sbin/irqbalance")
}
