.PHONY: format lint test build clean

ifeq ($(OS),Windows_NT)
    HOST_OS := windows
    RM = del /F /Q
    MKDIR = mkdir
	REDIRECT_DEV_NULL = 2> NUL
	SET= set
    AND = &&
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        HOST_OS := Linux
    endif
    ifeq ($(UNAME_S),Darwin)
        HOST_OS := macOS
    endif
    RM = rm -f
    MKDIR = mkdir -p
	REDIRECT_DEV_NULL = > /dev/null 2>&1 
	SET = export
	AND = ;

endif

GIT_REPO = $(notdir $(shell git remote get-url origin))
VERSION = $(shell git describe --tags --abbrev=0)
REVISION= $(shell git rev-parse --short HEAD)
APP_NAME := $(GIT_REPO:.git=)
APP_VERSION := $(VERSION)-$(REVISION)

REGISTRY := droneus
TARGET_ARCH = amd64
TARGET_OS = linux

# TARGET_ARCH=amd64
# TARGET_OS=windows

verbose:
	@echo $(OS)
	@echo $(ARCH)
	@echo $(APP_NAME)
	@echo $(APP_VERSION)

# Default command to run when no arguments are provided to make
all: lint test build

# Format your code
format:
	gofmt -s -w ./

# Lint your code
lint:
	golint

# Run tests
test:
	go test -v 
# Get go modules
get:
	go get

# Build
build: format get
	 $(SET) GOOS=$(TARGET_OS)$(AND) $(SET) GOARCH=$(TARGET_ARCH)$(AND) go build -ldflags "-X=dron-go-telebot/cmd.appVersion=$(APP_VERSION)" .

# Build container
image:
	docker build . -t $(REGISTRY)/$(APP_NAME):$(APP_VERSION)-$(TARGET_ARCH)

# Push image
push:
	docker push $(REGISTRY)/$(APP_NAME):$(APP_VERSION)-$(TARGET_ARCH)

# Clean up
clean:
	$(RM) dron-go-telebot* $(REDIRECT_DEV_NULL)

# Example usage to build for different platforms:
# make build OS=windows ARCH=amd64
# make build OS=darwin ARCH=amd64
# make build OS=linux ARCH=arm64
