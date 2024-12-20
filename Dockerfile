# Stage 1: Build the application
FROM golang:1.23-alpine as builder
RUN apk update && apk upgrade && \
    apk --update add git make bash build-base &\
    apk add --no-cache make protobuf-dev

# RUN apk add --no-cache git build-base

ENV DB_CONN=postgres
ENV DB_HOST=${DB_HOST}
ENV DB_NAME=${DB_DATABASE}
ENV DB_PASS=${DB_PASSWORD}
ENV DB_USER=${DB_USERNAME}
ENV PORT=${DB_PORT}
ENV APP_PORT=${PORT}

WORKDIR /voiasia_roozy_app

COPY /go.mod /go.sum ./

RUN go mod download

COPY . .

RUN go install github.com/joho/godotenv

RUN go install github.com/air-verse/air@latest

RUN go build -o main .

CMD ["air"]
