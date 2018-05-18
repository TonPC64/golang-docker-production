package server

import "github.com/gin-gonic/gin"

// NewServer function
func NewServer() {
	router := gin.Default()
	router.GET("/", root)
	router.Run()
}

func root(c *gin.Context) {
	c.String(200, "Hello World")
}
