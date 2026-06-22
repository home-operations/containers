package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/irqbalance:rolling")
	testhelpers.RequireFileExists(t, image, "/usr/sbin/irqbalance")
}
