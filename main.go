// Command gotest is a small Cobra-based CLI playground and proof-of-concept.
package main

import "github.com/AndriyKalashnykov/gotest/internal/cmd"

// Version is the release version of gotest.
//
// `make release` greps the declaration line below to create the git tag, so
// keep it a single line whose value is a double-quoted semver (vX.Y.Z). It also
// seeds the version reported by the `version` command for non-release builds;
// goreleaser overrides that via -ldflags (-X main.version=...) at release time.
const Version = "v0.0.14"

func main() {
	cmd.Execute()
}
