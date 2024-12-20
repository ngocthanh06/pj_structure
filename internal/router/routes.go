package router

import (
	"net/http"

	controller "github.com/user_service/internal/controller/user"
	"github.com/user_service/internal/database"
	"github.com/user_service/internal/middleware"
	repository "github.com/user_service/internal/repository/user"
	service "github.com/user_service/internal/service/user"

	"github.com/gin-gonic/gin"
)

type ServerInterface interface {
	GetPort() int
	GetDatabase() database.Service
	HelloWorldHandler(c *gin.Context)
	healthHandler(c *gin.Context)
}

type server struct {
	port int
	db   database.Service
}

func InitRouter(db database.Service, port int) *server {
	return &server{
		port: port,
		db:   db,
	}
}

func (s *server) GetPort() int {
	return s.port
}

func (s *server) GetDatabase() database.Service {
	return s.db
}

type UserController interface {
	GetContact(c *gin.Context)
}

func (s *server) ComposerApiService() http.Handler {
	router := gin.Default()
	router.Use(middleware.Cors(), middleware.UserMiddleware())

	userRepo := repository.NewUserRepository(s.db.DBInstance())
	userService := service.NewUserService(userRepo)
	userController := controller.NewUserController(userService)

	router.GET("/", s.HelloWorldHandler)
	router.GET("/health", s.healthHandler)

	v1 := router.Group("v1")
	setupRoute(v1, userController)

	return router
}

func setupRoute(router *gin.RouterGroup, userController UserController) {
	router.GET("/contact", userController.GetContact)
}

func (s *server) HelloWorldHandler(c *gin.Context) {
	resp := make(map[string]string)
	resp["message"] = "Hello World"

	c.JSON(http.StatusOK, resp)
}

func (s *server) healthHandler(c *gin.Context) {
	c.JSON(http.StatusOK, s.db.Health())
}
