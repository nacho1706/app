package routes

import (
	"test-go2/ent"
	"test-go2/internal/http/handlers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, client *ent.Client) {
	userHandler := handlers.NewUserHandler(client)

	api := router.Group("/api")

	users := api.Group("/users")
	{
		users.POST("/", userHandler.CreateUser)
		users.GET("/:id", userHandler.GetUser)
		users.PUT("/:id", userHandler.UpdateUser)
		users.DELETE("/:id", userHandler.DeleteUser)
	}
	categories := api.Group("/categories")
	{
		categories.POST("/", categoriesHandler.CreateUser)
		categories.GET("/:id", categoriesHandler.GetUser)
		categories.PUT("/:id", categoriesHandler.UpdateUser)
		categories.DELETE("/:id", categoriesHandler.DeleteUser)
	}
}
