package main

import (
	"log"
	"os"

	"github.com/AndriyKalashnykov/gotest/internal/calc"
)

func main() {
	log.Println("Hello: ", os.Getenv("USER"))
	calcRest := calc.Add(4, 6)
	log.Println("add: ", calcRest)
}
