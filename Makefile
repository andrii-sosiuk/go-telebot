.PHONY: format lint test build clean

# Project settings
APP_NAME=myapp
# Change these to the desired values
OS := $(shell uname -s)
ARCH=amd64


ifeq ($(OS),Windows_NT)
    RM = del /Q
    MKDIR = mkdir
else
    RM = rm -f
    MKDIR = mkdir -p
endif


# Default command to run when no arguments are provided to make
all: format lint test build

# Format your code
format:
	go fmt ./...

# Lint your code
lint:
	# Replace with your preferred linter command, e.g., golangci-lint
	golangci-lint run ./...

# Run tests
test:
	go test -v ./...

# Build your binary
# Example: make build OS=linux ARCH=amd64
# Default: make build (will use the above defaults for OS and ARCH)
build:
	GOOS=$(OS) GOARCH=$(ARCH) go build -ldflags "-X=dron-go-telebot/cmd.appVersion=v0.0.4" .

# Clean up
clean:
	rm -f $(BINARY_NAME)-*

# Example usage to build for different platforms:
# make build OS=windows ARCH=amd64
# make build OS=darwin ARCH=amd64
# make build OS=linux ARCH=arm64



