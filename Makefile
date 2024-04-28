.PHONY: format lint test build image push clean


REGISTRY := ghcr.io/andrii-sosiuk
TARGET_ARCH = amd64
TARGET_OS = linux

ifeq ($(OS),Windows_NT)
    HOST_OS := windows
    RM = del /F /Q
    MKDIR = mkdir
	REDIRECT_DEV_NULL = 2> NUL
	SET= set
    AND = &&
	IMAGE_EXIST = $(shell cmd /c "docker images -q $(REGISTRY)/$(APP_NAME) | findstr /r /c:\".\" > nul)
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
	# IMAGE_EXIST = $(shell docker images ls $(REGISTRY)/$(APP_NAME) | fgrep $(APP_NAME))
	IMAGE_EXIST = $(shell docker image ls "$(REGISTRY)/$(APP_NAME)" | grep -oP "$(REGISTRY)/$(APP_NAME)")
endif


GIT_REPO = $(notdir $(shell git remote get-url origin))
VERSION = $(shell git describe --tags --abbrev=0)
REVISION= $(shell git rev-parse --short HEAD)
APP_NAME := $(GIT_REPO:.git=)
APP_VERSION := $(VERSION)-$(REVISION)


# TARGET_ARCH=amd64
# TARGET_OS=windows

verbose:
	@echo $(OS)
	@echo $(ARCH)
	@echo $(APP_NAME)
	@echo $(APP_VERSION)
	@echo $(IMAGE_EXIST)

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
	 $(SET) CGO_ENABLED=0$(AND) $(SET) GOOS=$(TARGET_OS)$(AND) $(SET) GOARCH=$(TARGET_ARCH)$(AND) go build -v -o $(APP_NAME) -ldflags "-X=dron-go-telebot/cmd.appVersion=$(APP_VERSION)" .

# Build container
image:
	docker build . -t $(REGISTRY)/$(APP_NAME):v$(APP_VERSION)-$(TARGET_OS)-$(TARGET_ARCH)

# Push image
push:
	docker push $(REGISTRY)/$(APP_NAME):v$(APP_VERSION)-$(TARGET_OS)-$(TARGET_ARCH)

# Clean up
clean:
ifeq ($(IMAGE_EXIST),)
else
	docker rmi $(REGISTRY)/$(APP_NAME):v$(APP_VERSION)-$(TARGET_OS)-$(TARGET_ARCH) $(REDIRECT_DEV_NULL)
endif
	$(RM) $(APP_NAME)* $(REDIRECT_DEV_NULL)


# Example usage to build for different platforms:
# make build OS=windows ARCH=amd64
# make build OS=darwin ARCH=amd64
# make build OS=linux ARCH=arm64
