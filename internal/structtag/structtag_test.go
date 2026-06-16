package structtag

import (
	"reflect"
	"testing"
)

// sample mirrors the original playground domain: a struct annotated with a
// `validate` tag across required / optional / association fields.
type sample struct {
	Address          *string  `validate:"required"`
	NetworkID        *uint    `validate:"required"`
	NodeID           *uint    `validate:"optional"`
	PoolID           *uint    `validate:"optional"`
	ToTransactions   []string `validate:"optional,association"`
	FromTransactions []string `validate:"optional,association"`
	Untagged         string
	Skipped          string `validate:"-"`
	//lint:ignore U1000 read via reflection to verify unexported fields are skipped
	unexported string `validate:"required"`
}

func TestGroupFieldsByTag(t *testing.T) {
	want := map[string][]string{
		"required":             {"Address", "NetworkID"},
		"optional":             {"NodeID", "PoolID"},
		"optional,association": {"ToTransactions", "FromTransactions"},
	}

	t.Run("by value", func(t *testing.T) {
		got, err := GroupFieldsByTag(sample{}, "validate")
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if !reflect.DeepEqual(got, want) {
			t.Errorf("groups = %v, want %v", got, want)
		}
	})

	t.Run("by pointer", func(t *testing.T) {
		got, err := GroupFieldsByTag(&sample{}, "validate")
		if err != nil {
			t.Fatalf("unexpected error: %v", err)
		}
		if !reflect.DeepEqual(got, want) {
			t.Errorf("groups = %v, want %v", got, want)
		}
	})
}

func TestGroupFieldsByTag_DeclarationOrderPreserved(t *testing.T) {
	type ordered struct {
		C string `g:"x"`
		A string `g:"x"`
		B string `g:"x"`
	}
	got, err := GroupFieldsByTag(ordered{}, "g")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	want := []string{"C", "A", "B"} // field order, not alphabetical
	if !reflect.DeepEqual(got["x"], want) {
		t.Errorf("order = %v, want %v", got["x"], want)
	}
}

func TestGroupFieldsByTag_NoMatches(t *testing.T) {
	type none struct {
		A string `validate:"required"`
	}
	got, err := GroupFieldsByTag(none{}, "missing")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(got) != 0 {
		t.Errorf("groups = %v, want empty", got)
	}
}

func TestGroupFieldsByTag_Errors(t *testing.T) {
	var nilPtr *sample
	tests := []struct {
		name string
		in   any
	}{
		{"untyped nil", nil},
		{"non-struct", 42},
		{"string", "nope"},
		{"slice", []int{1, 2}},
		{"nil pointer", nilPtr},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if _, err := GroupFieldsByTag(tt.in, "validate"); err == nil {
				t.Errorf("GroupFieldsByTag(%#v) = nil error, want error", tt.in)
			}
		})
	}
}
