# gotest

A Go CLI playground/POC project built with Cobra, Viper, and GoReleaser.

## Build & Test

```bash
make deps        # Install dependency tools (staticcheck)
make lint        # Run staticcheck linter
make test        # Run tests with coverage
make build       # Build binary
make ci          # Run lint + test + build (CI pipeline)
make ci-run      # Run GitHub Actions workflow locally via act
make clean       # Clean build artifacts
```

## Project Structure

- `main.go` - Entry point, struct parsing examples, version constant
- `version.go` - CLI version command using go-version
- `internal/cmd/` - Cobra CLI root command and configuration
- `internal/calc/` - Math utilities with tests
- `hack/` - Release and tag management scripts
- `Dockerfile` - Alpine-based container image (built via goreleaser)

## Key Details

- **Module**: `github.com/AndriyKalashnykov/gotest`
- **Go version**: Defined in `go.mod`
- **Default branch**: `master`
- **CI triggers on**: `master` branch (push/PR) and `v*` tags
- **Release**: Tag-triggered via GoReleaser (`v*` tags)
- **Linter**: `staticcheck` (installed via `make deps`, version pinned in Makefile)
- **Test coverage**: `go test ./... -cover`

## CI/CD

GitHub Actions workflows in `.github/workflows/`:

| Workflow | File | Triggers | Steps |
|----------|------|----------|-------|
| CI | `ci.yml` | push to master, PRs, `v*` tags | Lint, Test, Build (via `make` targets) |
| Release | `release.yml` | `v*` tags | GoReleaser build + GitHub release + GHCR push |
| Cleanup | `cleanup-runs.yml` | weekly (Sunday) + manual | Delete old workflow runs (retain 7 days, min 5) |

## Skills

Use the following skills when working on related files:

| File(s) | Skill |
|---------|-------|
| `Makefile` | `/makefile` |
| `renovate.json` | `/renovate` |
| `README.md` | `/readme` |
| `.github/workflows/*.yml` | `/ci-workflow` |

When spawning subagents, always pass conventions from the respective skill into the agent's prompt.
