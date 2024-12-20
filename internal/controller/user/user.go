package controller

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/user_service/internal/utils"
)

type UserService interface {
}

type userController struct {
	userService UserService
}

func NewUserController(userService UserService) *userController {
	return &userController{
		userService: userService,
	}
}

func (u *userController) GetContact(c *gin.Context) {
	utils.JSONResponse(c, http.StatusOK, "success", nil)
}
