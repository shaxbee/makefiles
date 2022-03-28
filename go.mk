ifndef _include_go_mk
_include_go_mk = 1

include makefiles/shared.mk

GO ?= go
FORMAT_FILES ?= .
GO_TEST_TIMEOUT = 30s
GO_INTEGRATION_TEST_TIMEOUT = 1m

GOFUMPT_VERSION ?= v0.3.1
GOFUMPT_ROOT := $(BUILD)/gofumpt-$(GOFUMPT_VERSION)
GOFUMPT := $(GOFUMPT_ROOT)/gofumpt

GOLANGCILINT_VERSION ?= v1.45.2
GOLANGCILINT_ROOT := $(BUILD)/golangci-lint-$(GOLANGCILINT_VERSION)
GOLANGCILINT := $(GOLANGCILINT_ROOT)/golangci-lint
GOLANGCILINT_CONCURRENCY ?= 16

$(GOFUMPT): export GOBIN = $(abspath $(GOFUMPT_ROOT))

$(GOFUMPT):
	$(info $(_bullet) Installing <gofumpt>)
	@mkdir -p $(GOFUMPT_ROOT)
	$(GO) install mvdan.cc/gofumpt@$(GOFUMPT_VERSION)
	ln -sf $(subst $(BUILD)/,,$(GOFUMPT)) $(BUILD)/gofumpt

$(GOLANGCILINT):
	$(info $(_bullet) Installing <golangci-lint>)
	@mkdir -p $(GOLANGCILINT_ROOT)
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(GOLANGCILINT_ROOT) $(GOLANGCILINT_VERSION)
	ln -sf $(subst $(BUILD)/,,$(GOLANGCILINT)) $(BUILD)/golangci-lint

clean: clean-go

tools: $(GOFUMPT) $(GOLANGCILINT)

deps: deps-go

vendor: vendor-go

format: format-go

lint: lint-go

test: test-go

test-cover: test-cover-go

integration-test: integration-test-go

integration-test-cover: integration-test-cover-go

.PHONY: clean-go deps-go format-go lint-go test-go test-cover-go integration-test-go integration-test-cover-go

clean-go: ## Clean Go
	$(info $(_bullet) Cleaning <go>)
	rm -rf vendor/

deps-go: ## Tidy go dependencies
	$(info $(_bullet) Tidy dependencies <go>)
	$(GO) mod tidy
	$(GO) mod download

vendor-go: ## Vendor Go dependencies
	$(info $(_bullet) Vendoring dependencies <go>)
	$(GO) mod vendor

format-go: $(GOFUMPT) ## Format Go code
	$(info $(_bullet) Formatting code)
	gofumpt -w $(FORMAT_FILES)

lint-go: $(GOLANGCILINT)
	$(info $(_bullet) Linting <go>) 
	golangci-lint run --concurrency $(GOLANGCILINT_CONCURRENCY) ./...

test-go: ## Run Go tests
	$(info $(_bullet) Running tests <go>)
	$(GO) test -timeout $(GO_TEST_TIMEOUT) ./...
	
test-cover-go: ## Run Go tests with coverage
	$(info $(_bullet) Running tests with coverage <go>)
	$(GO) test -timeout $(GO_TEST_TIMEOUT) -coverprofile=coverage.out ./...

integration-test-go: ## Run Go integration tests
	$(info $(_bullet) Running integration tests <go>)
	$(GO) test -timeout $(GO_INTEGRATION_TEST_TIMEOUT) -tags integration -count 1 ./...

integration-test-cover-go: ## Run Go integration tests with coverage
	$(info $(_bullet) Running integration tests with coverage <go>)
	$(GO) test -timeout $(GO_INTEGRATION_TEST_TIMEOUT) -coverprofile=coverage.out -tags integration -count 1 ./...

endif