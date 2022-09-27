package main

import (
	"fmt"
	"github.com/AndriyKalashnykov/gotest/internal/calc"
	"github.com/worldline-go/struct2"
	"github.com/worldline-go/struct2/types"
	"log"
	"os"
	"sort"
	"time"
)

const Version = "v0.0.8"

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

func main() {

	//Execute()
	fmt.Println("Version:\t", Version)

	if 2 == 1 {
		log.Println("Hello : ", os.Getenv("USER"))
		calcRest := calc.Add(4, 6)
		log.Println("add: ", calcRest)
	}

	type ColorGroup struct {
		ID     int        `json:"id"`
		Name   string     `json:"name"`
		Colors []string   `json:"colors"`
		Date   types.Time `json:"time"`
	}

	d, _ := time.Parse(time.RFC3339, "2006-01-02T15:04:05Z")

	group := ColorGroup{
		ID:     1,
		Name:   "Reds",
		Colors: []string{"Crimson", "Red", "Ruby", "Maroon"},
		Date:   types.Time{Time: d},
	}

	result := (&struct2.Decoder{}).SetTagName("json").Map(group) // default tag name is "struct"

	fmt.Printf("%#v", result)
	SortPrint(result)

}
