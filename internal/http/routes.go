package routes

import (
	"test-go2/ent"
	"test-go2/internal/http/handlers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, client *ent.Client) {
	userHandler := handlers.NewUserHandler(client)

	api := router.Group("/api")

	api.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// User routes
	users := api.Group("/users")
	{
		users.GET("/", userHandler.List)
		users.POST("/", userHandler.Create)
		// TODO: Implement these methods in UserHandler
		// users.GET("/:id", userHandler.GetByID)
		// users.PUT("/:id", userHandler.Update)
		// users.DELETE("/:id", userHandler.Delete)
	}

	// TODO: Implement CategoryHandler and Transaction routes
	// categories := api.Group("/categories")
	// {
	//     categories.GET("/", categoryHandler.List)
	//     categories.POST("/", categoryHandler.Create)
	//     categories.GET("/:id", categoryHandler.GetByID)
	//     categories.PUT("/:id", categoryHandler.Update)
	//     categories.DELETE("/:id", categoryHandler.Delete)
	// }
}
