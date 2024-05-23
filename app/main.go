package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand/v2"
	"net/http"
	"os"
)

func main() {
	port := flag.Int("port", 80, "")
	flag.Parse()

	path := os.Getenv("APP_PATH")
	if len(path) == 0 {
		log.Panic("APP_PATH environment variable is not set")
	}
	fmt.Println("Application path: ", path)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!\n")
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "OK\n")
	})

	http.HandleFunc(path, func(w http.ResponseWriter, r *http.Request) {
		rn := rand.IntN(100)
		rs := fmt.Sprint(rn)
		fmt.Fprint(w, rs)
	})

	addr := fmt.Sprintf(":%d", *port)
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		fmt.Println("Error starting the server: ", err)
	}
}
