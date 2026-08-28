## ----------------------------------------------------------------------
## Builder for creating Docker images that behave similar to Virtual
## Machines for use with Vagrant. This takes advantage if the buildx
## builder in docker which can cross-compile images for other targets.
## ----------------------------------------------------------------------

# These can be overidden with env vars.
REGISTRY ?= rofrano
IMAGE_NAME ?= nyu-devops-base
IMAGE_TAG ?= fa26
IMAGE ?= $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
PLATFORM ?= "linux/amd64,linux/arm64"

# Set up the Docker build environment
.EXPORT_ALL_VARIABLES:

DOCKER_BUILDKIT = 1

.SILENT:

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: all
all: help

##@ Development

.PHONY: clean
clean:	## Removes all dangling build cache
	$(info Removing all dangling build cache)
	docker buildx prune -f

.PHONY: init
init: export DOCKER_BUILDKIT=1
init:	## Creates the buildx instance
	$(info Initializing Builder...)
	-docker buildx create --name=qemu
	docker buildx use qemu 
	docker buildx inspect --bootstrap

.PHONY: build
build:	## Build all of the project Docker images
	$(info Building $(IMAGE) for $(PLATFORM)...)
	docker buildx build --pull --platform=$(PLATFORM) --tag $(IMAGE) --push .

##@ Runtime

.PHONY: run
run:	## Run a vagrant VM using this image
	$(info Bringing up container with Docker...)
	docker run --rm -v $(PWD)/app -w /app $(IMAGE) bash

.PHONY: remove
remove:	## Stop and remove the buildx builder
	$(info Stopping and removing the builder image...)
	docker buildx stop
	docker buildx rm
