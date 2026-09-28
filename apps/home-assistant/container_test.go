package main

import (
	"testing"

	helpers "github.com/home-operations/containers/tests"
)

func Test(t *testing.T) {
	image := helpers.GetTestImage("ghcr.io/home-operations/home-assistant:rolling")
	c := helpers.RequireHTTPEndpoint(t, image, helpers.HTTPTestConfig{Port: "8123"}, nil)

	helpers.RequireExecSucceeds(t, c, "go2rtc", "--version")

	// Custom integrations such as HACS rely on Home Assistant installing their requirements
	// into the venv at runtime, so check that path works for the container user.
	helpers.RequireExecSucceeds(t, c, "/config/.venv/bin/python3", "-m", "uv", "pip", "install", "--quiet",
		"--python", "/config/.venv/bin/python3", "aiogithubapi")
	helpers.RequireExecSucceeds(t, c, "/config/.venv/bin/python3", "-c", "import aiogithubapi")
}
