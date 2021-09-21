ifndef _include_proto_mk
_include_proto_mk := 1

include makefiles/shared.mk
include makefiles/go.mk

BUF_VERSION ?= v1.0.0-rc1
BUF_ROOT := $(BUILD)/buf-$(BUF_VERSION)
BUF := $(BUF_ROOT)/bin/buf

PROTOC_GEN_GO_VERSION := v1.26
PROTOC_GEN_GO_ROOT := $(BUILD)/protoc-gen-go-$(PROTOC_GEN_GO_VERSION)
PROTOC_GEN_GO := $(PROTOC_GEN_GO_ROOT)/protoc-gen-go

PROTOC_GEN_GO_GRPC_VERSION := v1.1
PROTOC_GEN_GO_GRPC_ROOT := $(BUILD)/protoc-gen-go-grpc-$(PROTOC_GEN_GO_GRPC_VERSION)
PROTOC_GEN_GO_GRPC := $(PROTOC_GEN_GO_GRPC_ROOT)/protoc-gen-go-grpc

PROTOC_GO_OUT ?= .
PROTOC_GO_MODULE ?= $(shell $(GO) list -m)

$(BUF):
	$(info $(_bullet) Installing <buf>)
	@mkdir -p $(BUF_ROOT)
	curl -sSfL "https://github.com/bufbuild/buf/releases/download/$(BUF_VERSION)/buf-$(OS)-$(shell uname -m).tar.gz" | \
	tar -xzf - -C "$(BUF_ROOT)" --strip-components 1

$(PROTOC_GEN_GO): export GOBIN = $(abspath $(PROTOC_GEN_GO_ROOT))

$(PROTOC_GEN_GO):
	$(info $(_bullet) Installing <protoc-gen-go>)
	@mkdir -p $(dir $(PROTOC_GEN_GO))
	go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)

$(PROTOC_GEN_GO_GRPC): export GOBIN = $(abspath $(PROTOC_GEN_GO_GRPC_ROOT))

$(PROTOC_GEN_GO_GRPC): $(BUILD_BIN)
	$(info $(_bullet) Installing <protoc-gen-go-grpc>)
	@mkdir -p $(dir $(PROTOC_GEN_GO_GRPC))
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)

.PHONY: generate generate-proto lint lint-proto

generate: generate-proto

generate-proto: export PATH = $(PROTOC_GEN_GO_ROOT):$(PROTOC_GEN_GO_GRPC_ROOT):$(shell echo $$PATH)

generate-proto: $(BUF) $(PROTOC_GEN_GO) $(PROTOC_GEN_GO_GRPC)
	$(info $(_bullet) Generating <proto>)
	$(BUF) generate

lint: lint-proto

lint-proto: $(BUF)
	$(info $(_bullet) Linting <proto>)
	$(BUF) lint

endif