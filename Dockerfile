# Stage 1: Build the Go binary
FROM golang:1.17 AS builder

# Set necessary environment variables
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Set the working directory inside the container
WORKDIR /app

# Copy the Go modules files
COPY go.mod .
COPY go.sum .

# Download dependencies
RUN go mod download

# Copy the rest of the application source code
COPY . .

# Build the Go binary
RUN go build -o app main.go

# Stage 2: Create a lightweight image
FROM alpine:latest

# Set a label for the image
LABEL maintainer="bdsuman <mesuman@yahoo.com>"

# Set the working directory inside the container
WORKDIR /root/

# Copy the built binary from the builder stage
COPY --from=builder /app/app .

# Expose the port the server listens on
EXPOSE 8080

# Set environment variables
ENV PORT=8080

# Command to run the executable
CMD ["./app"]
