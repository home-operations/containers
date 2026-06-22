package main

import (
	"testing"

	"github.com/home-operations/containers/testhelpers"
)

func Test(t *testing.T) {
	image := testhelpers.GetTestImage("ghcr.io/home-operations/qbittorrent-libtorrentv1:rolling")
	testhelpers.RequireHTTPEndpoint(t, image, testhelpers.HTTPTestConfig{Port: "8080"}, nil)
}
