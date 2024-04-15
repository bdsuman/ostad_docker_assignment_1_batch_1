# Dockerfile for Go Application

This Dockerfile provides instructions to build a Docker image for the provided Go application.

## Requirements
- Docker should be installed on your system.

## Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/xaadu/ostad_docker_assignment_1_batch_1.git
   ```

2. Navigate to the directory containing the Go application files:
   ```bash
   cd ostad_docker_assignment_1_batch_1
   ```

3. Create a Dockerfile in the same directory and paste the following content:

   ```Dockerfile
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
   ```

4. Save the Dockerfile.

5. Build the Docker image using the following command:
   ```bash
   docker build -t go_server_image .
   ```

6. Once the image is built, run the Docker container:
   ```bash
   docker run -p 8080:8080 go_server_image
   ```

7. Test if the server is successfully working by accessing the endpoints mentioned in the `README.md` file.

### Check if the server is running
1. Go to `http://localhost:<given_port>` and check if you see "`Hello, from Ostad! <3`".
2. Go to `http://localhost:<given_port>/health` and check if you see "`{"Status": "OK"}`".

