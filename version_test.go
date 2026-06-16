package main

import "testing"

func TestRenderVersion(t *testing.T) {
	const (
		v = "v1.2.3"
		c = "abc1234"
		d = "06-16-2026"
	)
	tests := []struct {
		name      string
		shortened bool
		output    string
		want      string
	}{
		{"json long", false, "json", `{"Version":"v1.2.3","Commit":"abc1234","Date":"06-16-2026"}` + "\n"},
		{"yaml long", false, "yaml", "Commit: abc1234\nDate: 06-16-2026\nVersion: v1.2.3\n"},
		{"short overrides json", true, "json", "Commit: abc1234\nDate: 06-16-2026\nVersion: v1.2.3\n"},
		{"short with yaml", true, "yaml", "Commit: abc1234\nDate: 06-16-2026\nVersion: v1.2.3\n"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := renderVersion(tt.shortened, tt.output, v, c, d); got != tt.want {
				t.Errorf("renderVersion(%v, %q) =\n%q\nwant\n%q", tt.shortened, tt.output, got, tt.want)
			}
		})
	}
}
