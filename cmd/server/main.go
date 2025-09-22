package main

import (
	"log"
	"net/http"
	"os"
	"test-go2/ent"
	routes "test-go2/internal/http"

	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error: .env didnt load correctly")
	}

	mysqlenv := os.Getenv("DATABASE_URL")
	if mysqlenv == "" {
		log.Fatalf("error al conectar la DB")
	}

	client, err := ent.Open("mysql", mysqlenv)
	if err != nil {
		log.Fatal("Error loading credentials: ", mysqlenv)
	}
	defer client.Close()

	r := gin.Default()
	routes.SetupRoutes(r, client)

	log.Println("Servidor corriendo en :8080")
	if err := r.Run(":8080"); err != nil && err != http.ErrServerClosed {
		log.Fatalf("❌ error al iniciar server: %v", err)
	}
}
