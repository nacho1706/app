package main

import (
	"log"
	"net/http"
	"os"
	"test-go2/ent"
	routes "test-go2/internal/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
)

func main() {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		log.Fatal("❌ DATABASE_URL environment variable is required")
	}

	client, err := ent.Open("mysql", dsn)
	if err != nil {
		log.Fatalf("❌ error al conectar la DB: %v", err)
	}
	defer client.Close()

	r := gin.Default()

	routes.SetupRoutes(r, client)

	log.Println("Servidor corriendo en :8080")
	if err := r.Run(":8080"); err != nil && err != http.ErrServerClosed {
		log.Fatalf("❌ error al iniciar server: %v", err)
	}
}
