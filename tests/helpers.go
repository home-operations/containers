package helpers

import (
	"context"
	"fmt"
	"os"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/log"
	"github.com/testcontainers/testcontainers-go/wait"

	dockerclient "github.com/moby/moby/client"
)

// GetTestImage returns the image to test from TEST_IMAGE env var or falls back to the default
func GetTestImage(defaultImage string) string {
	image := os.Getenv("TEST_IMAGE")
	if image == "" {
		return defaultImage
	}
	return image
}

// ContainerConfig holds optional container configuration
type ContainerConfig struct {
	Env map[string]string // Environment variables to set in the container
}

// applyContainerConfig applies optional container configuration
func applyContainerConfig(config *ContainerConfig) []testcontainers.ContainerCustomizer {
	var opts []testcontainers.ContainerCustomizer

	if config == nil {
		return opts
	}

	if len(config.Env) > 0 {
		opts = append(opts, testcontainers.WithEnv(config.Env))
	}

	return opts
}

// tLogConsumer pipes container stdout/stderr to t.Log so failing tests surface what the container said.
//
// Safe against the "Log in goroutine after Test completed" panic: the log-pump goroutine is joined
// before the test finishes. CleanupContainer registers a t.Cleanup that runs Terminate ->
// stopLogProduction(), which blocks on the pump's done channel synchronously (testcontainers-go
// v0.43.0). Re-verify this invariant on any major testcontainers upgrade.
type tLogConsumer struct{ t *testing.T }

func (c *tLogConsumer) Accept(l testcontainers.Log) {
	c.t.Helper()
	c.t.Logf("[%s] %s", l.LogType, l.Content)
}

// runContainer is a tiny helper to start a container with common patterns: log forwarding,
// CleanupContainer registration, and immediate error check.
func runContainer(t *testing.T, ctx context.Context, image string, opts ...testcontainers.ContainerCustomizer) testcontainers.Container {
	t.Helper()

	opts = append([]testcontainers.ContainerCustomizer{
		testcontainers.WithLogger(log.TestLogger(t)),
		testcontainers.WithLogConsumers(&tLogConsumer{t: t}),
	}, opts...)

	c, err := testcontainers.Run(ctx, image, opts...)
	testcontainers.CleanupContainer(t, c)
	require.NoError(t, err)
	return c
}

// requireExitZero waits for container exit (via wait strategy set by caller) and asserts the exit code is zero.
func requireExitZero(t *testing.T, ctx context.Context, c testcontainers.Container, what string) {
	t.Helper()
	state, err := c.State(ctx)
	require.NoError(t, err)
	require.Equal(t, 0, state.ExitCode, what)
}

// HTTPTestConfig holds the configuration for HTTP endpoint tests
type HTTPTestConfig struct {
	Port       string
	Path       string
	StatusCode int
	Timeout    time.Duration // optional startup timeout for the HTTP wait strategy (0 = library default)
}

// RequireHTTPEndpoint tests that an HTTP endpoint is accessible and returns the expected status code
func RequireHTTPEndpoint(t *testing.T, image string, httpConfig HTTPTestConfig, containerConfig *ContainerConfig) {
	t.Helper()

	if httpConfig.Path == "" {
		httpConfig.Path = "/"
	}
	if httpConfig.StatusCode == 0 {
		httpConfig.StatusCode = 200
	}

	portStr := httpConfig.Port + "/tcp"

	httpWait := wait.ForHTTP(httpConfig.Path).WithPort(portStr).WithStatusCodeMatcher(func(status int) bool {
		return status == httpConfig.StatusCode
	})
	if httpConfig.Timeout > 0 {
		httpWait = httpWait.WithStartupTimeout(httpConfig.Timeout)
	}

	opts := []testcontainers.ContainerCustomizer{
		testcontainers.WithExposedPorts(portStr),
		testcontainers.WithWaitStrategy(
			wait.ForListeningPort(portStr),
			httpWait,
		),
	}

	opts = append(opts, applyContainerConfig(containerConfig)...)

	_ = runContainer(t, t.Context(), image, opts...)
}

// RequireFileExists tests that a file exists in the image by inspecting its filesystem directly,
// without starting the container. Works for images with no shell or executables.
func RequireFileExists(t *testing.T, image string, filePath string) {
	t.Helper()

	ctx := t.Context()

	ctr, err := testcontainers.Run(ctx, image,
		testcontainers.WithNoStart(),
		testcontainers.WithCmd("/"),
		testcontainers.WithLogger(log.TestLogger(t)),
	)
	testcontainers.CleanupContainer(t, ctr)
	require.NoError(t, err)

	cli, err := dockerclient.New(dockerclient.FromEnv)
	require.NoError(t, err)
	defer cli.Close()

	_, err = cli.ContainerStatPath(ctx, ctr.GetContainerID(), dockerclient.ContainerStatPathOptions{Path: filePath})
	require.NoError(t, err, "file %q should exist in image %q", filePath, image)
}

// RequireCommandSucceeds tests that a command runs successfully in the container (exit code 0)
func RequireCommandSucceeds(t *testing.T, image string, config *ContainerConfig, entrypoint string, args ...string) {
	t.Helper()

	opts := []testcontainers.ContainerCustomizer{
		testcontainers.WithEntrypoint(entrypoint),
		testcontainers.WithWaitStrategy(wait.ForExit()),
	}

	if len(args) > 0 {
		opts = append(opts, testcontainers.WithEntrypointArgs(args...))
	}

	opts = append(opts, applyContainerConfig(config)...)

	ctx := t.Context()
	container := runContainer(t, ctx, image, opts...)
	requireExitZero(t, ctx, container, fmt.Sprintf("command '%s %v' should succeed", entrypoint, args))
}
