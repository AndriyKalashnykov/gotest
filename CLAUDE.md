# gotest

A Go CLI playground/POC project built with Cobra, Viper, and GoReleaser.

## Build & Test

```bash
make deps        # Install dependency tools (staticcheck)
make lint        # Run staticcheck linter
make test        # Run tests with coverage
make build       # Build binary
make ci          # Run lint + test + build (CI pipeline)
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
- **Go version**: Defined in `go.mod` (currently 1.25.7)
- **Main branch**: `master`
- **CI triggers on**: `main` branch (push/PR) -- note: this differs from the default branch name `master`
- **Release**: Tag-triggered via GoReleaser (`v*` tags)
- **Linter**: `staticcheck` (installed via `make deps`)
- **Test coverage**: `go test ./... -cover`

## Skills

Use the following skills when working on related files:

| File(s) | Skill |
|---------|-------|
| `Makefile` | `/makefile` |
| `renovate.json` | `/renovate` |
| `README.md` | `/readme` |
| `.github/workflows/*.yml` | `/ci-workflow` |

When spawning subagents, always pass conventions from the respective skill into the agent's prompt.
