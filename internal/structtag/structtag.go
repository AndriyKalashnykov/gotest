// Package structtag groups a struct's exported field names by the value of a
// chosen struct tag, using reflection.
//
// It is the core demonstration of this playground: given a struct annotated
// with, for example, `validate:"required"`, GroupFieldsByTag reports which
// fields fall under each distinct tag value.
package structtag

import (
	"fmt"
	"reflect"
)

// GroupFieldsByTag walks v — a struct or a (possibly nested) pointer to a
// struct — and groups the names of its exported fields by the value of the
// struct tag named tag.
//
// Fields without the tag, and fields whose tag value is "-", are skipped. The
// returned map's keys are the distinct tag values; each slice preserves the
// struct's field-declaration order. Only top-level fields are considered;
// nested structs are not descended into.
//
// An error is returned if v is nil, is a nil pointer, or does not resolve to a
// struct.
func GroupFieldsByTag(v any, tag string) (map[string][]string, error) {
	rv := reflect.ValueOf(v)
	for rv.Kind() == reflect.Pointer {
		if rv.IsNil() {
			return nil, fmt.Errorf("structtag: nil pointer to %s", rv.Type().Elem())
		}
		rv = rv.Elem()
	}
	if rv.Kind() != reflect.Struct {
		return nil, fmt.Errorf("structtag: want a struct or pointer to struct, got %s", rv.Kind())
	}

	t := rv.Type()
	groups := make(map[string][]string)
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		if !f.IsExported() {
			continue
		}
		value, ok := f.Tag.Lookup(tag)
		if !ok || value == "-" {
			continue
		}
		groups[value] = append(groups[value], f.Name)
	}
	return groups, nil
}
