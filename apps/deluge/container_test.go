package main

import (
	"context"
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/home-operations/deluge:rolling")
	t.Run("HTTP endpoint test", func(t *testing.T) {
		testhelpers.TestHTTPEndpoint(t, ctx, image,
      testhelpers.HTTPTestConfig{
        Port: "8122",
      },
      &testhelpers.ContainerConfig{
        Env: map[string]string{
          "DELUGE_BIN": "deluge-web",
        },
      },
    )
	})
}
