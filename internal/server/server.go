package server

import (
	"fmt"
	"net/http"
	"os"
	"strconv"
	"time"

	_ "github.com/joho/godotenv/autoload"

	"github.com/user_service/internal/database"
	"github.com/user_service/internal/router"
)

func NewServer() *http.Server {
	port, _ := strconv.Atoi(os.Getenv("PORT"))
	db := database.New()
	newServer := router.InitRouter(db, port)

	// Declare Server config
	server := &http.Server{
		Addr:         fmt.Sprintf(":%d", newServer.GetPort()),
		Handler:      newServer.ComposerApiService(),
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	return server
}
