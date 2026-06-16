package cmd

import (
	"bytes"
	"encoding/json"
	"reflect"
	"testing"
)

func runFields(t *testing.T, args ...string) string {
	t.Helper()
	var out bytes.Buffer
	RootCmd.SetOut(&out)
	RootCmd.SetErr(&out)
	RootCmd.SetArgs(append([]string{"fields"}, args...))
	if err := RootCmd.Execute(); err != nil {
		t.Fatalf("fields command failed: %v", err)
	}
	return out.String()
}

func TestFieldsCommand_DefaultTag(t *testing.T) {
	got := runFields(t)

	var groups map[string][]string
	if err := json.Unmarshal([]byte(got), &groups); err != nil {
		t.Fatalf("output is not valid JSON: %v\n%s", err, got)
	}

	want := map[string][]string{
		"required":             {"Address", "NetworkID"},
		"optional":             {"NodeID", "PoolID"},
		"optional,association": {"ToTransactions", "FromTransactions"},
	}
	if !reflect.DeepEqual(groups, want) {
		t.Errorf("groups = %v, want %v", groups, want)
	}
}

func TestFieldsCommand_UnknownTagIsEmpty(t *testing.T) {
	got := runFields(t, "--tag", "json")

	var groups map[string][]string
	if err := json.Unmarshal([]byte(got), &groups); err != nil {
		t.Fatalf("output is not valid JSON: %v\n%s", err, got)
	}
	if len(groups) != 0 {
		t.Errorf("groups = %v, want empty for an unused tag", groups)
	}
}
