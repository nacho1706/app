package handlers

import (
	"net/http"

	"test-go2/ent"

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	client *ent.Client
}

func NewUserHandler(client *ent.Client) *UserHandler {
	return &UserHandler{client: client}
}

func (h *UserHandler) List(c *gin.Context) {
	users, err := h.client.User.Query().All(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, users)
}

func (h *UserHandler) Create(c *gin.Context) {
	var body struct {
		Name  string `json:"name"`
		Email string `json:"email"`
	}
	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.client.User.Create().
		SetName(body.Name).
		SetEmail(body.Email).
		Save(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, user)
}
