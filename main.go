package main

import (
	"fmt"
	"log"
	"os"
	"reflect"
	"sort"
	"time"

	"github.com/AndriyKalashnykov/gotest/internal/calc"
	"github.com/AndriyKalashnykov/gotest/internal/cmd"
	"github.com/worldline-go/struct2"
)

const Version = "v0.0.14"

func SortPrint(m map[string]interface{}) {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	for _, k := range keys {
		fmt.Printf("Key:%v Type: %T, Value: %v\n", k, m[k], m[k])
	}
}

type Transaction struct {
	Name *string `validate:"required"`
}

type Account struct {
	Address          *string       `validate:"required"`
	NetworkID        *uint         `validate:"required"`
	NodeID           *uint         `validate:"optional"`
	PoolID           *uint         `validate:"optional"`
	ToTransactions   []Transaction `validate:"optional,association"`
	FromTransactions []Transaction `validate:"optional,association"`
}

type FieldsByTag struct {
	TagName              string
	Required             []string
	Optional             []string
	OptionalAssociations []string
}

var AccountTaggedFields = make(map[string]*FieldsByTag)

const tagNameValidate = "validate"

func parseStruct(tagName string, v reflect.Value, tag reflect.StructTag, fn func(string, reflect.Value, reflect.StructTag), tf map[string]*FieldsByTag) {
	v = reflect.Indirect(v)

	switch v.Kind() {
	case reflect.Struct:
		t := v.Type()
		for i := 0; i < t.NumField(); i++ {
			switch t.Field(i).Tag.Get(tagName) {
			case "required":
				tf[tagName].Required = append(tf[tagName].Required, t.Field(i).Name)
			case "optional":
				tf[tagName].Optional = append(tf[tagName].Optional, t.Field(i).Name)
			case "optional,association":
				tf[tagName].OptionalAssociations = append(tf[tagName].OptionalAssociations, t.Field(i).Name)
			}
			//fmt.Println("field: ", t.Field(i).Name, ", tag value: ", t.Field(i).Tag.Get("validate"))
			parseStruct(tagName, v.Field(i), t.Field(i).Tag, fn, tf)
		}
	case reflect.Slice, reflect.Array:
		if v.Type().Elem().Kind() == reflect.String {
			for i := 0; i < v.Len(); i++ {
				parseStruct(tagName, v.Index(i), tag, fn, tf)
			}
		}
	case reflect.String:
		fn(tagName, v, tag)
	}
}

func translate(tagName string, v reflect.Value, tag reflect.StructTag) {
	if !v.CanSet() {
		// unexported fields cannot be set
		//fmt.Printf("Skipping %q %s because it cannot be set.\n", v.String(), tag)
		return
	}
	val := tag.Get(tagNameValidate)
	if val == "" {
		return
	}
	// modify values if needed
	//v.SetString(fmt.Sprintf("value %q translated with %s", v.String(), val))
}

func main() {

	cmd.Execute()
	//fmt.Println("Version:\t", Version)

	if 2 == 1 {
		log.Println("Hello : ", os.Getenv("USER"))
		calcRest := calc.Add(4, 6)
		log.Println("add: ", calcRest)

		type ColorGroup struct {
			ID     int       `json:"id"`
			Name   string    `json:"name"`
			Colors []string  `json:"colors"`
			Date   time.Time `json:"time"`
		}

		d, _ := time.Parse(time.RFC3339, "2006-01-02T15:04:05Z")

		group := ColorGroup{
			ID:     1,
			Name:   "Reds",
			Colors: []string{"Crimson", "Red", "Ruby", "Maroon"},
			Date:   d,
		}

		result := (&struct2.Decoder{}).SetTagName("json").Map(group) // default tag name is "struct"

		fmt.Printf("%#v", result)
		SortPrint(result)
	}

	AccountTaggedFields[tagNameValidate] = &FieldsByTag{TagName: tagNameValidate, Required: []string{}, Optional: []string{}, OptionalAssociations: []string{}}

	address := "1345345623452345"
	networkID := uint(1)
	nodeId := uint(1)
	poolId := uint(1)
	tr1 := "Tr1"
	structObj := Account{
		Address:   &address,
		NetworkID: &networkID,
		NodeID:    &nodeId,
		PoolID:    &poolId,
		ToTransactions: []Transaction{{
			Name: &tr1,
		}},
	}
	parseStruct(tagNameValidate, reflect.ValueOf(&structObj), "", translate, AccountTaggedFields)
	//fmt.Printf("%#v\n", v)

	fmt.Printf("%#v\\n", AccountTaggedFields[tagNameValidate])
}
