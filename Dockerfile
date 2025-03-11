FROM golang:1.19-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN go build -o tumangaonline-api App.go

# Use a smaller image for the final container
FROM alpine:latest

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/tumangaonline-api .

# Railway automatically assigns a PORT environment variable
# We'll use that instead of hardcoding 5000
EXPOSE ${PORT:-5000}

# Command to run the application
CMD ["./tumangaonline-api"]