ifndef _include_go_mk
_include_go_mk = 1

include makefiles/shared.mk
include makefiles/gobin.mk

GO ?= go
FORMAT_FILES ?= .

GOFUMPT := bin/gofumpt

GOLANGCILINT := bin/golangci-lint
GOLANGCILINT_VERSION ?= 1.31.0
GOLANGCILINT_CONCURRENCY ?= 16

$(GOFUMPT): $(GOBIN)
	$(info $(_bullet) Installing <gofumpt>)
	@mkdir -p bin
	GOBIN=bin $(GOBIN) mvdan.cc/gofumpt

$(GOLANGCILINT): $(GOBIN)
	$(info $(_bullet) Installing <golangci-lint>)
	@mkdir -p bin
	GOBIN=bin $(GOBIN) github.com/golangci/golangci-lint/cmd/golangci-lint@v$(GOLANGCILINT_VERSION)

clean: clean-go

deps: deps-go

vendor: vendor-go

format: format-go

lint: lint-go

test: test-go

test-coverage: test-coverage-go

integration-test: integration-test-go

.PHONY: deps-go format-go lint-go test-go test-coverage-go integration-test-go

clean-go: ## Clean Go
	$(info $(_bullet) Cleaning <go>)
	rm -rf vendor/

deps-go: ## Download Go dependencies
	$(info $(_bullet) Downloading dependencies <go>)
	$(GO) mod download

vendor-go: ## Vendor Go dependencies
	$(info $(_bullet) Vendoring dependencies <go>)
	$(GO) mod vendor

format-go: $(GOFUMPT) ## Format Go code
	$(info $(_bullet) Formatting code)
	$(GOFUMPT) -w $(FORMAT_FILES)

lint-go: $(GOLANGCILINT)
	$(info $(_bullet) Linting <go>) 
	$(GOLANGCILINT) run --concurrency $(GOLANGCILINT_CONCURRENCY) ./...

test-go: ## Run Go tests
	$(info $(_bullet) Running tests <go>)
	$(GO) test ./...
	
test-coverage-go: ## Run Go tests with coverage
	$(info $(_bullet) Running tests with coverage <go>) 
	$(GO) test -cover ./...

integration-test-go: ## Run Go integration tests
	$(info $(_bullet) Running integration tests <go>) 
	$(GO) test -tags integration -count 1 ./...

endif