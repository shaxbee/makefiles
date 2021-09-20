ifndef _include_protoc_mk
_include_protoc_mk := 1

include makefiles/shared.mk
include makefiles/go.mk

PROTOC_VERSION ?= v3.15.8
PROTOC_ROOT := $(BUILD)/protoc-$(PROTOC_VERSION)
PROTOC := $(PROTOC_ROOT)/bin/protoc

PROTO_PATH ?= ./api-spec

# find all proto files in PROTO_PATH excluding protoc built-ins
# generate paths relative to PROTO_PATH
PROTO_FILES := $(foreach f,\
	$(shell find $(abspath $(PROTO_PATH)) -name '*.proto' ! -path $(abspath $(BUILD))),\
	$(f:$(abspath $(PROTO_PATH))/%=%)\
)

PROTOC_GEN_GO := $(PROTOC_ROOT)/bin/protoc-gen-go
PROTOC_GEN_GO_GRPC := $(PROTOC_ROOT)/bin/protoc-gen-go-grpc

PROTOC_GO_OUT ?= .
PROTOC_GO_MODULE ?= $(shell $(GO) list -m)

_protoc_os := $(OS)
ifeq ($(OS),darwin)
	_protoc_os = osx
endif

_protoc_arch := $(ARCH)
ifeq ($(ARCH),amd64)
	_protoc_arch = x86_64
endif

$(PROTOC):
	$(info $(_bullet) Installing <protoc>)
	@mkdir -p $(PROTOC_ROOT)
	curl -sSfL -o "$(PROTOC_ROOT)/protoc.zip" "https://github.com/protocolbuffers/protobuf/releases/download/$(PROTOC_VERSION)/protoc-$(PROTOC_VERSION:v%=%)-$(_protoc_os)-$(_protoc_arch).zip"
	unzip -q -d "$(PROTOC_ROOT)" "$(PROTOC_ROOT)/protoc.zip"

$(PROTOC_GEN_GO_GRPC) $(PROTOC_GEN_GO): export GOBIN := $(abspath $(PROTOC_ROOT))/bin

$(PROTOC_GEN_GO):
	$(info $(_bullet) Installing <protoc-gen-go>)
	@mkdir -p $(dir $(PROTOC_GEN_GO))
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26

$(PROTOC_GEN_GO_GRPC): $(BUILD_BIN)
	$(info $(_bullet) Installing <protoc-gen-go-grpc>)
	@mkdir -p $(dir $(PROTOC_GEN_GO_GRPC))
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

.PHONY: generate generate-proto

generate: generate-proto

generate-proto: export PATH := $(PROTOC_ROOT)/bin:$(PATH)

generate-proto: $(PROTOC) $(PROTOC_GEN_GO) $(PROTOC_GEN_GO_GRPC)
	$(info $(_bullet) Generating <proto>)
	protoc --proto_path=$(abspath $(PROTO_PATH)) \
	--go_opt=module=$(PROTOC_GO_MODULE) \
	--go_out=$(PROTOC_GO_OUT) \
	$(PROTO_FILES)

endif