include .env

# Simple Makefile for a Go project
MIGRATE_COMMAND := migrate
MIGRATION_DIR := internal/database/migrations
MIGRATION_EXT := sql
URL_DATABASE := postgres://${DB_USERNAME}:${DB_PASSWORD}@127.0.0.1:${DB_PORT}/${DB_DATABASE}?sslmode=disable
DOCKER_COMPOSE := docker-compose
BASH_COMMAND := $(DOCKER_COMPOSE) exec app bash

# Build the application
all: build test

build:
	@echo "Building..."
	
	
	@go build -o main main.go

# Run the application
run:
	@go run main.go
# Create DB container
docker-run:
	@if docker compose up -d --build 2>/dev/null; then \
		: ; \
	else \
		echo "Falling back to Docker Compose V1"; \
		docker-compose up --build; \
	fi

# Shutdown DB container
docker-down:
	@if docker compose down 2>/dev/null; then \
		: ; \
	else \
		echo "Falling back to Docker Compose V1"; \
		docker-compose down; \
	fi

# Test the application
test:
	@echo "Testing..."
	@go test ./... -v
# Integrations Tests for the application
itest:
	@echo "Running integration tests..."
	@go test ./internal/database -v

# Clean the binary
clean:
	@echo "Cleaning..."
	@rm -f main

# Live Reload
watch:
	@if command -v air > /dev/null; then \
            air; \
            echo "Watching...";\
        else \
            read -p "Go's 'air' is not installed on your machine. Do you want to install it? [Y/n] " choice; \
            if [ "$$choice" != "n" ] && [ "$$choice" != "N" ]; then \
                go install github.com/air-verse/air@latest; \
                air; \
                echo "Watching...";\
            else \
                echo "You chose not to install air. Exiting..."; \
                exit 1; \
            fi; \
        fi

.PHONY: all build run test clean watch docker-run docker-down itest

.PHONY: migrate-create
migrate-create:
	@if [ -z "$(name)" ]; then \
  		echo "Error: Please provide a migration name using 'make migrate-create name==<migration_name>'";\
  		exit 1;\
	fi
	@$(MIGRATE_COMMAND) create -ext $(MIGRATION_EXT) -dir $(MIGRATION_DIR) -seq $(name)

.PHONY: migrate-up
migrate-up:
	$(MIGRATE_COMMAND) -database ${URL_DATABASE} -path $(MIGRATION_DIR) up

.PHONY: migrate-down
migrate-down:
	@$(MIGRATE_COMMAND) -database ${URL_DATABASE} -path $(MIGRATION_DIR) down


.PHONY: migrate-force
migrate-force:
	@if [ -z "$(version)" ]; then \
  		echo "Error: Please provide a migration version using ";\
  		exit 1;\
	fi
	@$(MIGRATE_COMMAND) -database $(URL_DATABASE) -path $(MIGRATION_DIR) force $(version)

.PHONY: bash
bash:
	@docker exec -it voiasia_roozy_app sh

.PHONY: migrate-version
migrate-version:
	@$(MIGRATE_COMMAND) -database $(URL_DATABASE) -path $(MIGRATION_DIR) version
