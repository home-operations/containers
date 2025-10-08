package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/jackett:rolling")
	testhelpers.TestHTTPEndpoint(t, ctx, image, testhelpers.HTTPTestConfig{
		Port: "9117",
		StatusCode: 400,
	}, nil)
}
