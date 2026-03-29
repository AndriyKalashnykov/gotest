[![CI](https://github.com/AndriyKalashnykov/gotest/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/AndriyKalashnykov/gotest/actions/workflows/ci.yml)
[![Hits](https://hits.sh/github.com/AndriyKalashnykov/gotest.svg?view=today-total&style=plastic)](https://hits.sh/github.com/AndriyKalashnykov/gotest/)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://app.renovatebot.com/dashboard#github/AndriyKalashnykov/gotest)

# gotest

A Go CLI playground and proof-of-concept project built with Cobra, Viper, and GoReleaser. Demonstrates struct parsing, CLI commands, and release automation.

## Quick Start

```bash
make deps      # install tools (staticcheck)
make build     # build the binary
make test      # run tests with coverage
make run       # build and run gotest
```

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| [GNU Make](https://www.gnu.org/software/make/) | 3.81+ | Build orchestration |
| [Go](https://go.dev/dl/) | 1.25+ | Go toolchain (see `go.mod`) |
| [Docker](https://www.docker.com/) | latest | Container image builds (optional) |

Install all required dependencies:

```bash
make deps
```

## Available Make Targets

Run `make help` to see all available targets.

### Build & Run

| Target | Description |
|--------|-------------|
| `make build` | Build binary |
| `make clean` | Clean build artifacts |
| `make clean-all` | Clean all build artifacts including system-wide installs |
| `make run` | Build and run gotest |
| `make image-build` | Build Docker image |

### Code Quality

| Target | Description |
|--------|-------------|
| `make lint` | Run linter |
| `make test` | Run tests with coverage |
| `make test-coverage-view` | Run tests and open coverage report in browser |

### CI

| Target | Description |
|--------|-------------|
| `make ci` | Run lint, tests, and build (CI pipeline) |
| `make ci-run` | Run GitHub Actions workflow locally using [act](https://github.com/nektos/act) |

### Release

| Target | Description |
|--------|-------------|
| `make version` | Print current version(tag) |
| `make release` | Create and push a release (validates semver) |
| `make release-test-local` | Build binaries locally without publishing |
| `make tag` | Create a release tag |
| `make tags-push` | Push all tags to remote |
| `make changelog-generate` | Generate changelog |

### Utilities

| Target | Description |
|--------|-------------|
| `make deps` | Install dependency tools (idempotent) |
| `make update` | Update dependency packages to latest versions |
| `make show` | Show gotest binary locations |
| `make renovate-validate` | Validate Renovate configuration |

## Installation

### Binaries

Prebuilt binaries are available on the [releases page](https://github.com/AndriyKalashnykov/gotest/releases).

Download and install a binary locally:

```bash
./hack/get-gotest.sh
```

### From source

```bash
go install github.com/AndriyKalashnykov/gotest@latest
```

## CI/CD

GitHub Actions runs on every push to `master`, tags `v*`, and pull requests.

| Job | Triggers | Steps |
|-----|----------|-------|
| **ci** | push to master, PRs, tags | Lint, Test, Build |
| **goreleaser** | tag `v*` | Build binaries, Docker image, GitHub release |

[Renovate](https://docs.renovatebot.com/) keeps dependencies up to date with platform automerge enabled.
