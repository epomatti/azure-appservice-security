package main

import (
	"flag"
	"fmt"
	"math/rand/v2"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

var path = ""

func main() {
	port := flag.Int("port", 80, "")
	flag.Parse()

	path = os.Getenv("APP_PATH")

	r := gin.Default()
	g := r.Group(path)
	g.GET("", get)
	g.GET("/", get)
	g.GET("/health", healthCheck)
	g.GET("/health/", healthCheck)

	addr := fmt.Sprintf(":%d", *port)
	r.Run(addr)
}

func get(c *gin.Context) {
	rn := rand.IntN(10000)
	c.JSON(http.StatusOK, gin.H{
		"app":    path,
		"random": rn,
	})
}

func healthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
	})
}
