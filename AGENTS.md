# AGENTS.md: containers

Guidance for AI coding agents (and humans) writing Go in this repository.
Unlike the fleet's other Go repos, there's no application code here: Go
exists solely to test the container images this repo builds, via
`testcontainers-go`. The fleet's general Go-conventions template (idiomatic
Go, `log/slog`, `caarlos0/env`, `pflag`, mise build/lint/test tasks,
...) doesn't apply here: there's no `main.go`, no config to load, no CLI, no
server. This repo is the one exception in the fleet that doesn't reuse that
template; everything below is specific to this repo's own shape.

## Working in this repo: AI usage, commits, and safety

This repo doesn't carry its own `CONTRIBUTING.md`; GitHub serves the
org-wide one from [`home-operations/.github`](https://github.com/home-operations/.github/blob/main/CONTRIBUTING.md),
which includes an AI Usage Policy that applies to any AI coding agent here:
assistive use only, a human must author the majority of any change, AI use
must be disclosed, a human reviews every line before submission, and the
contributor must be able to explain any line a reviewer asks about. AI must
never write the PR description, an issue, or a reply to a human on the
contributor's behalf. Read the policy itself rather than trusting this
summary; it can change without this file being updated to match. This
matters especially here: it would be easy to let AI bulk-generate a dozen
near-identical `container_test.go` files unattended, which is exactly the
"predominantly AI-generated" pattern the policy prohibits.

- PR titles follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
  `<type>[(scope)][!]: <description>`. Individual commit messages don't have
  to follow the format, though matching it is fine. Sign off commits:
  `git commit -s`.
- Never `git commit`, `git push`, or open a PR unless asked to. Ask before
  any destructive or hard-to-reverse action instead of defaulting to it.
- Don't state a library's API from memory: verify against `pkg.go.dev` or
  this project's own code, e.g. `tests/helpers.go`, before assuming a
  `testcontainers-go` helper exists or behaves a certain way.
- After a change, actually run the affected app's test (see "Running"
  below) before calling it done, and check `.github/workflows/` for what CI
  actually enforces beyond that (formatting, `go vet`, ...) rather than
  assuming.

## Layout

One `apps/<name>/container_test.go` per image, `package main`, testing the
image built from `apps/<name>/`. Shared helpers live in `tests/helpers.go`
(package `helpers`): check that file for what's already available (things
like `RequireCommandSucceeds`, `RequireHTTPEndpoint`, `RequireFileExists`
as of this writing) before hand-rolling container lifecycle code in an
individual `container_test.go`. Add a new capability to `helpers` instead;
that's the DRY boundary in this repo.

## Conventions

- `testify/require`, not `assert`: a failed image test should stop
  immediately rather than cascade into a second, confusing failure.
- Every helper takes `t *testing.T` first, calls `t.Helper()`, and
  registers cleanup via `testcontainers.CleanupContainer(t, c)`; never leak
  a container past the test.
- `TEST_IMAGE` overrides the default image under test
  (`helpers.GetTestImage`), so a local build task can point tests at a
  just-built image instead of the published tag; check `mise tasks` for the
  actual task name.
- Idempotent and side-effect-free: a test only asserts against the image
  under test (command exit code, HTTP response, file presence in the
  filesystem) and never depends on or mutates state from another test.
- Still idiomatic Go where it applies: `go vet`-clean, no unchecked errors
  outside the established `require.NoError` pattern, table-driven subtests
  (`t.Run`) if a single app's test grows multiple cases.
- `gofmt -s` runs via the shared `home-operations/.github` lefthook config
  on every staged `.go` file; check `.github/workflows/` for whatever else
  CI enforces (e.g. `go vet`) before assuming lefthook's formatting pass is
  the only gate.

## Running

Run `mise tasks` for the actual local build+test task name and invocation;
don't assume it matches another repo's, and don't assume CI selects which
apps to build from `.github/labeler.yaml`, that file drives PR labels only.
Check `.github/workflows/` for the step that actually selects changed apps.
