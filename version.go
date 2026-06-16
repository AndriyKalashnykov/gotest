package main

import (
	"encoding/json"
	"fmt"

	"github.com/AndriyKalashnykov/gotest/internal/cmd"
	"github.com/spf13/cobra"
)

var (
	shortened = false
	// version/commit/date are overridden at build time via -ldflags
	// (-X main.version=... etc.). version defaults to the release constant.
	version = Version
	commit  = "none"
	date    = "unknown"
	output  = "json"

	versionCmd = &cobra.Command{
		Use:   "version",
		Short: "Print the build version information",
		RunE: func(c *cobra.Command, _ []string) error {
			fmt.Fprint(c.OutOrStdout(), renderVersion(shortened, output, version, commit, date))
			return nil
		},
	}
)

// renderVersion formats the build information. JSON (the default) is emitted
// only in long form; the short flag and any non-json output format fall back to
// a plain Key: value listing.
func renderVersion(shortened bool, output, version, commit, date string) string {
	if !shortened && output == "json" {
		b, _ := json.Marshal(struct {
			Version string
			Commit  string
			Date    string
		}{version, commit, date})
		return string(b) + "\n"
	}
	return fmt.Sprintf("Commit: %s\nDate: %s\nVersion: %s\n", commit, date, version)
}

func init() {
	versionCmd.Flags().BoolVarP(&shortened, "short", "s", false, "Print just the version number.")
	versionCmd.Flags().StringVarP(&output, "output", "o", "json", "Output format. One of 'yaml' or 'json'.")
	cmd.RootCmd.AddCommand(versionCmd)
}
