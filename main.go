package main

import (
	"github.com/AndriyKalashnykov/gotest/internal/calc"
	"log"
	"os"
)
func main() {
	Execute()
	log.Println("Hello : ", os.Getenv("USER"))
	calcRest := calc.Add(4, 6)
	log.Println("add: ", calcRest)
}
