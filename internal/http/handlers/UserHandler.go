package handlers

import (
	"net/http"

	"test-go2/ent"
	"test-go2/internal/utils"

	"github.com/gin-gonic/gin"
)

type UserHandler struct {
	client *ent.Client
}

func NewUserHandler(client *ent.Client) *UserHandler {
	return &UserHandler{client: client}
}

func (h *UserHandler) List(c *gin.Context) {
	params := utils.ParsePaginationParams(c)

	total, err := h.client.User.Query().Count(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to count usersss" + err.Error()})
		return
	}

	users, err := h.client.User.Query().
		Offset(params.Offset).
		Limit(params.Limit).
		Order(ent.Asc("id")).
		All(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch users: " + err.Error()})
		return
	}

	response := utils.CreatePaginationResponse(users, params, total)

	c.JSON(http.StatusOK, response)
}

func (h *UserHandler) Create(c *gin.Context) {
	var body struct {
		AccountID int    `json:"account_id" binding:"required,min=1"`
		FirstName string `json:"first_name" binding:"required,max=30"`
		Currency  string `json:"currency" binding:"omitempty,len=3"`
		Locale    string `json:"locale" binding:"omitempty,max=10"`
		Timezone  string `json:"timezone" binding:"omitempty,max=50"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Validation failed",
			"details": err.Error(),
		})
		return
	}

	if body.Currency == "" {
		body.Currency = "ARS"
	}
	if body.Locale == "" {
		body.Locale = "es-AR"
	}
	if body.Timezone == "" {
		body.Timezone = "America/Argentina/Buenos_Aires"
	}

	user, err := h.client.User.Create().
		SetAccountID(body.AccountID).
		SetFirstName(body.FirstName).
		SetCurrency(body.Currency).
		SetLocale(body.Locale).
		SetTimezone(body.Timezone).
		Save(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, user)
}
