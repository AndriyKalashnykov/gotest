[![CI](https://github.com/AndriyKalashnykov/gotest/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/AndriyKalashnykov/gotest/actions/workflows/ci.yml)
[![Hits](https://hits.sh/github.com/AndriyKalashnykov/gotest.svg?view=today-total&style=plastic)](https://hits.sh/github.com/AndriyKalashnykov/gotest/)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://app.renovatebot.com/dashboard#github/AndriyKalashnykov/gotest)

# gotest — Go CLI Playground

A Go CLI playground and proof-of-concept built with **Cobra** (commands), **Viper** (config),
and **GoReleaser** (release automation). It demonstrates reflection-based struct-tag parsing and
serves as a reference for the project tooling used across the portfolio: a **mise**-provisioned
dev toolchain, a `static-check` quality gate (staticcheck + govulncheck + Trivy + gitleaks),
**GitHub Actions** CI, **GoReleaser**-published binaries and a **GHCR** Docker image, and
**Renovate** dependency automation.

## Tech Stack

| Component | Technology |
|-----------|------------|
| Language | Go 1.25 (see `go.mod`) |
| CLI framework | [Cobra](https://github.com/spf13/cobra) |
| Configuration | [Viper](https://github.com/spf13/viper) |
| Release automation | [GoReleaser](https://goreleaser.com/) |
| Container image | Docker (Alpine), published to GHCR |
| CI/CD | GitHub Actions |
| Static analysis | staticcheck, govulncheck, Trivy, gitleaks |
| Tool versioning | [mise](https://mise.jdx.dev/) |
| Dependency updates | [Renovate](https://docs.renovatebot.com/) |

## Quick Start

```bash
make deps      # provision pinned dev tools via mise
make build     # build the binary
make test      # run tests with coverage
make run       # build and run gotest
```

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [mise](https://mise.jdx.dev/) | latest | Provisions pinned dev tools (staticcheck, govulncheck, Trivy, gitleaks, act, node) |
| [Go](https://go.dev/dl/) | 1.25+ | Go toolchain (see `go.mod`) |
| [GNU Make](https://www.gnu.org/software/make/) | 3.81+ | Build orchestration |
| [Docker](https://www.docker.com/) | latest | Container image builds (optional) |

Install [mise](https://mise.jdx.dev/getting-started.html), then provision the dev tools:

```bash
make deps
```

## Usage

```bash
# Print build information (version, commit, date) as JSON or YAML
gotest version
gotest version --short
gotest version --output yaml

# Demonstrate reflection-based struct-tag parsing: group a sample struct's
# fields by a struct tag (default "validate") and print the result as JSON
gotest fields
gotest fields --tag validate
```

`gotest fields` reflects over a sample `Account` struct and groups its fields by
tag value (`required`, `optional`, `optional,association`) — the core
proof-of-concept this playground exists to demonstrate.

## Installation

### Binaries

Prebuilt binaries are available on the [releases page](https://github.com/AndriyKalashnykov/gotest/releases).

Download and install a binary locally:

```bash
./hack/get-gotest.sh
```

### Docker

A container image is published to the GitHub Container Registry on each `v*` tag:

```bash
docker pull ghcr.io/andriykalashnykov/gotest:latest
docker run --rm ghcr.io/andriykalashnykov/gotest:latest --help
```

### From source

```bash
go install github.com/AndriyKalashnykov/gotest@latest
```

## Available Make Targets

Run `make help` to see all available targets.

### Build & Run

| Target | Description |
|--------|-------------|
| `make all` | Build all (alias for `build`) |
| `make build` | Build binary |
| `make clean` | Clean build artifacts |
| `make clean-all` | Clean all build artifacts including system-wide installs |
| `make run` | Build and run gotest |
| `make image-build` | Build Docker image |
| `make show` | Show gotest binary locations |

### Code Quality

| Target | Description |
|--------|-------------|
| `make static-check` | Run all static analysis (lint + vulncheck + secrets + trivy-fs) |
| `make lint` | Run staticcheck linter |
| `make vulncheck` | Scan for known Go vulnerabilities (govulncheck) |
| `make trivy-fs` | Scan filesystem dependencies and secrets for CVEs (Trivy) |
| `make secrets` | Scan the working tree for leaked secrets (gitleaks) |
| `make test` | Run tests with coverage |
| `make test-coverage-view` | Run tests and open coverage report in browser |

### CI

| Target | Description |
|--------|-------------|
| `make ci` | Run static analysis, tests, and build (CI pipeline) |
| `make ci-run` | Run GitHub Actions workflow locally using [act](https://github.com/nektos/act) |

### Release

| Target | Description |
|--------|-------------|
| `make version` | Print current version (tag) |
| `make release` | Create and push a release (validates semver) |
| `make release-test-local` | Build binaries locally without publishing |
| `make tag` | Create a release tag |
| `make tags-push` | Push all tags to remote |
| `make changelog-generate` | Generate changelog |
| `make tags-delete-local` | Delete all local tags |
| `make tags-delete-remote` | Delete all remote tags |
| `make tags-delete-all` | Delete all local and remote tags |
| `make tags-delete-current` | Delete the current version tag locally and remotely |

### Utilities

| Target | Description |
|--------|-------------|
| `make deps` | Provision pinned dev tools via mise (idempotent) |
| `make update` | Update dependency packages to latest versions |
| `make renovate-validate` | Validate Renovate configuration |

## CI/CD

GitHub Actions runs on every push to `master`, on `v*` tags, and on pull requests.

| Workflow | Triggers | Jobs |
|----------|----------|------|
| **CI** (`ci.yml`) | push to master, PRs, `v*` tags | `changes` (path filter) → `static-check`, `build`, `test` → `ci-pass` |
| **Release** (`release.yml`) | `v*` tags | `goreleaser`: build binaries, Docker image (GHCR), GitHub release |
| **Cleanup** (`cleanup-runs.yml`) | weekly (Sunday) + manual | Delete old workflow runs (retain 7 days, keep min 5) |

`ci-pass` aggregates the CI jobs into a single status check — set it as the required status check
in branch protection so a failing build cannot merge.

### Required Secrets and Variables

| Name | Type | Used by | Purpose |
|------|------|---------|---------|
| `GH_ACCESS_TOKEN` | Secret | `release` (`goreleaser`) | GitHub PAT with `write:packages` for pushing the image to GHCR (`ghcr.io/andriykalashnykov/gotest`, a user-namespace package). `GITHUB_TOKEN` alone cannot create user-namespace packages. |

`GITHUB_TOKEN` is provided automatically by GitHub Actions and needs no configuration.

[Renovate](https://docs.renovatebot.com/) keeps dependencies up to date, with automerge enabled
on green CI.
