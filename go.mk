ifndef _include_go_mk
_include_go_mk = 1

include makefiles/shared.mk

GO ?= go
FORMAT_FILES ?= .

GOFUMPT_VERSION ?= v0.1.1
GOFUMPT_ROOT := $(BUILD)/gofumpt-$(GOFUMPT_VERSION)
GOFUMPT := $(GOFUMPT_ROOT)/gofumpt

GOLANGCILINT_VERSION ?= v1.42.0
GOLANGCILINT_ROOT := $(BUILD)/golangci-lint-$(GOLANGCILINT_VERSION)
GOLANGCILINT := $(GOLANGCILINT_ROOT)/golangci-lint
GOLANGCILINT_CONCURRENCY ?= 16

_go_modules = $(shell for file in `find . -type f -name go.mod`; do dirname $$file; done)

$(GOFUMPT): export GOBIN = $(abspath $(GOFUMPT_ROOT))

$(GOFUMPT):
	$(info $(_bullet) Installing <gofumpt>)
	@mkdir -p $(GOFUMPT_ROOT)
	$(GO) install mvdan.cc/gofumpt@$(GOFUMPT_VERSION)

$(GOLANGCILINT): export GOBIN = $(abspath $(GOLANGCILINT_ROOT))

$(GOLANGCILINT):
	$(info $(_bullet) Installing <golangci-lint>)
	$(GO) install github.com/golangci/golangci-lint/cmd/golangci-lint@$(GOLANGCILINT_VERSION)

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

# TODO: remove _go_modules hack when https://github.com/golang/go/issues/45713 is released

deps-go: ## Tidy go dependencies
	$(info $(_bullet) Tidy dependencies <go>)
	@for module in $(_go_modules); do \
		cd $${module} && \
		$(GO) mod tidy && \
		echo "go mod tidy ($${module})" && \
		$(GO) mod download && \
		echo "go mod download ($${module})" && \
		cd - >/dev/null; \
	done

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
	@for module in $(_go_modules); do \
		cd $${module} && \
		echo "go test ./... ($${module})" && \
		$(GO) test ./...; \
		cd - >/dev/null; \
	done
	
test-coverage-go: ## Run Go tests with coverage
	$(info $(_bullet) Running tests with coverage <go>) 
		$(info $(_bullet) Running tests <go>)
	@for module in $(_go_modules); do \
		cd $${module} && \
		echo "go test -cover ./... ($${module})" && \
		$(GO) test -cover ./...; \
		cd - >/dev/null; \
	done

integration-test-go: ## Run Go integration tests
	$(info $(_bullet) Running integration tests <go>) 
	@for module in $(_go_modules); do \
		cd $${module} && \
		echo "o test -tags integration -count 1 ./... ($${module})" && \
		$(GO) test -tags integration -count 1 ./...; \
		cd - >/dev/null; \
	done

endif