# gotest

A Go CLI playground/POC project built with Cobra, Viper, and GoReleaser.

## Build & Test

```bash
make deps          # Provision pinned dev tools via mise (.mise.toml)
make static-check  # lint + vulncheck + secrets + trivy-fs
make test          # Run tests with coverage
make build         # Build binary
make ci            # static-check + test + build (CI pipeline)
make ci-run        # Run GitHub Actions workflow locally via act
make clean         # Clean build artifacts
```

## Project Structure

- `main.go` - Entry point, struct parsing examples, version constant
- `version.go` - CLI version command using go-version
- `internal/cmd/` - Cobra CLI root command and configuration
- `internal/calc/` - Math utilities with tests
- `hack/` - Release and tag management scripts
- `.mise.toml` - Pinned dev tooling (staticcheck, govulncheck, Trivy, gitleaks, act, node)
- `Dockerfile` - Alpine-based container image (built via goreleaser)

## Key Details

- **Module**: `github.com/AndriyKalashnykov/gotest`
- **Go version**: Defined in `go.mod`
- **Default branch**: `master`
- **CI triggers on**: `master` branch (push/PR) and `v*` tags
- **Release**: Tag-triggered via GoReleaser (`v*` tags)
- **Tooling**: provisioned by [mise](https://mise.jdx.dev/) (`.mise.toml`); the Go toolchain stays single-sourced in `go.mod`
- **Static analysis**: `make static-check` = staticcheck + govulncheck + Trivy (fs) + gitleaks
- **Test coverage**: `go test ./... -cover`

## CI/CD

GitHub Actions workflows in `.github/workflows/`:

| Workflow | File | Triggers | Steps |
|----------|------|----------|-------|
| CI | `ci.yml` | push to master, PRs, `v*` tags | `changes` → `static-check`, `build`, `test` → `ci-pass` (via `make` targets) |
| Release | `release.yml` | `v*` tags | GoReleaser build + GitHub release + GHCR push |
| Cleanup | `cleanup-runs.yml` | weekly (Sunday) + manual | Delete old workflow runs (retain 7 days, min 5) |

## Skills

Use the following skills when working on related files:

| File(s) | Skill |
|---------|-------|
| `Makefile` | `/makefile` |
| `renovate.json` | `/renovate` |
| `README.md` | `/readme` |
| `.github/workflows/*.{yml,yaml}` | `/ci-workflow` |

When spawning subagents, always pass conventions from the respective skill into the agent's prompt.
