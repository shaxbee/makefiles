ifndef _include_shared_mk
_include_shared_mk := 1

OS ?= $(shell uname -s | tr [:upper:] [:lower:])
ARCH ?= $(shell uname -m)

ifeq ($(ARCH),x86_64)
	ARCH = amd64
endif

BIN = $(abspath bin)

$(BIN):
	@mkdir -p $(BIN)

.PHONY: help clean deps vendor generate format lint test test-coverage integration-test build bootrap deploy run dev debug

all: deps generate format lint test build

help: ## Help
	@cat $(sort $(MAKEFILE_LIST)) | grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | sort

clean: clean-bin ## Clean targets

deps: ## Download dependencies

vendor: ## Vendor dependencies

generate: ## Generate code

format: ## Format code

lint: ## Lint code

test: ## Run tests

test-coverage: ## Run tests with coverage

integration-test: ## Run integration tests

build: ## Build all targets

bootstrap: ## Bootstrap

deploy: ## Deploy

run: ## Run

dev: ## Run in development mode

debug: ## Run in debug mode

.PHONY: clean-bin git-dirty git-hooks

clean-bin: ## Clean installed tools
	$(info $(_bullet) Cleaning <bin>)
	rm -rf bin/

_bullet := $(shell printf "\033[34;1m▶\033[0m")

endif