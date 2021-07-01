package main

import (
	"github.com/AndriyKalashnykov/hello/internal/calc"
	"log"
	"os"
)

func main() {
	log.Println("Hello: ", os.Getenv("USER"))
	calcRest := calc.Add(4, 6)
	log.Println("add: ", calcRest)
}
