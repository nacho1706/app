package main

import (
	"log"
	"net/http"
	"os"
	"test-go2/ent"
	"test-go2/internal/http/handlers"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	dsn := os.Getenv("DATABASE_URL")

	client, err := ent.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("❌ error al conectar la DB: %v", err)
	}
	defer client.Close()

	r := gin.Default()

	userHandler := handlers.NewUserHandler(client)

	// api := r.Group("/api")
	// {
	// 	api.GET("/users", userHandler.List)
	// 	api.POST("/users", userHandler.Create)
	// }

	log.Println("Servidor corriendo en :8080")
	if err := r.Run(":8080"); err != nil && err != http.ErrServerClosed {
		log.Fatalf("❌ error al iniciar server: %v", err)
	}
}
