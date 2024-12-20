# Service Project

## Introduction
This project contains Service implemented with Go. The services are containerized using Docker and managed with Docker Compose. This README provides instructions on setting up, building, and running the project..

## Required
- [Go](https://golang.org/doc/install) (version 1.16+)
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Make (for Unix-based systems)

## Project Setup

### Project Structure
``` bash
    .
    ├── cmd
    │   └── root.go                         # Entry point of the application, where the application is initialized and run
    ├── internal
    │   ├── controller
    │   │   └── user
    │   │   │   └── user.go                 # Controller to handle requests related to User
    │   ├── database
    │   │   └── migrations
    │   │   │   ├── 000001_users.down.sql   # SQL file to revert the migration for the User table
    │   │   │   └── 000001_users.up.sql     # SQL file to create the User table
    │   │   ├── database_test.go            # Test file related to database operations
    │   │   └── database.go                 # Test file related to database operations
    │   ├── middleware
    │   │   ├── authentication.go           # Middleware for user authentication
    │   │   └── cors.go                     # Middleware for handling Cross-Origin Resource Sharing (CORS)
    │   ├── model
    │   │   ├── entity
    │   │   ├── tels.go                     # Defines the data structure (entity) for User
    │   │   │   └── user.go                 # Defines the data structure (entity) for Use
    │   │   └── todo
    │   │       └── tels.go                 # Custom request or data structures, e.g., CreateTelTodo, IdTelTodo
    │   ├── repository
    │   │   └── tels.go                     # Data access functions for User (Repository pattern)
    │   ├── router
    │   │   ├── routes.go                   # Defines application routes
    │   │   └── routes_test.go              # Test file for routes
    │   ├── server
    │   │   ├── server.go                   # File for server initialization and configuration
    │   │   └── server_struct.go            # Defines the server structure
    │   ├── service
    │   │   ├── grpc
    │   │   │   └── user.go                 # Business logic for gRPC services related to User
    │   │   └── user
    │   │       └── user.go                 # Business logic for services related to User
    │   └── utils
    │       └── helper_response.go          # Helper functions for creating HTTP responses
    ├── .env.example                        # Example file for environment variables
    ├── Dockerfile                          # Dockerfile for building the service image
    ├── go.mod                              # Go module file declaring dependencies
    ├── main.go                             # Main file of the application, where the application is started
    ├── Makerfile                           # Makefile for automating tasks like building, testing, and running services
    ├── data.sql                            # SQL file with initial data or database schema
    ├── docker-compose.yml                  # Docker Compose file to set up and run the required containers for the services
    └── README.md                           # Documentation file explaining the setup and usage of the project (multiple README files)
```

### Clone repository 
```bash 
git clone <repository_url> 
cd <repository_directory>
```
### Set up environment variables
```bash
cp contact-service/.env.example contact-service/.env
cp user-service/.env.example user-service/.env
```

### Build Docker
```bash
make docker-run
```

### Start Project
```bash
make docker-start
```

### Down Docker
``` bash
make docker-down
```

### Access to containers
``` bash
make user-service-bash      # user service
make contact-service-bash   # contact service
```

### Migrate
``` bash
make migrate-create name="<database_name>"
make migrate-up
make migrate-down
make migrate-force
```

## Repository

```bash
.
└── internal
    └── app
        ├── controller
        │   ├── user    
        │   │   └── user.go # 3. Create controller to handle requests related to User
        ├── router
        │   └── routes.go   # 4. Configure routes and initialize dependencies
        ├── service
        │   └── user
        │       └── user.go # 2. Create service logic for User, inject repository
        └── repository
            └── user
                └── user.go # 1. Create repository declaration for User, perform database operations
```

1. Create repository declaration for User, perform database operations: 
``` go
package repository

import (
	"gorm.io/gorm"
)

type userRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *userRepository {
	return &userRepository{
		db: db,
	}
}
```

2. Create service logic for User, inject repository
``` go

package service

type UserRepository interface {
}

type userService struct {
	userRepository UserRepository
}

func NewUserService(userRepository UserRepository) *userService {
	return &userService{
		userRepository: userRepository,
	}
}

```

3. Create controller to handle requests related to User
``` go
package controller

import (
	"context"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	grpcService "github.com/proto-files/grpc_service"
	pb "github.com/proto-files/pb"
	"github.com/user_service/internal/utils"
	"google.golang.org/grpc/status"
)

type UserService interface {
}

type userController struct {
	userService UserService
	grpcClients *grpcService.GrpcClients
}

func NewUserController(userService UserService, grpcClients *grpcService.GrpcClients) *userController {
	return &userController{
		userService: userService,
		grpcClients: grpcClients,
	}
}
```

4. Configure routes and initialize dependencies
``` go
func (s *server) ComposerApiService() http.Handler {
    ...
	userRepo := repository.NewUserRepository(s.db.DBInstance())
	userService := service.NewUserService(userRepo)
	userController := controller.NewUserController(userService, clients)
    ...
}
```

### How to run?
#### Access url 
``` go
http://localhost:8000/health
```

#### Response data:
``` go
{
    idle: "1",
    in_use: "0",
    max_idle_closed: "0",
    max_lifetime_closed: "0",
    message: "It's healthy",
    open_connections: "1",
    status: "up",
    wait_count: "0",
    wait_duration: "0s"
}

```
