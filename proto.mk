ifndef _include_proto_mk
_include_proto_mk := 1

include makefiles/shared.mk
include makefiles/go.mk

BUF_VERSION ?= v1.6.0
BUF_ROOT := $(BUILD)/buf-$(BUF_VERSION)
BUF := $(BUF_ROOT)/bin/buf

$(BUF):
	$(info $(_bullet) Installing <buf>)
	@mkdir -p $(BUF_ROOT)
	curl -sSfL "https://github.com/bufbuild/buf/releases/download/$(BUF_VERSION)/buf-$(shell uname -s)-$(shell uname -m).tar.gz" | \
	tar -xzf - -C "$(BUF_ROOT)" --strip-components 1
	ln -sf $(subst $(BUILD)/,,$(BUF)) $(BUILD)/buf

.PHONY: generate generate-proto lint lint-proto

generate: generate-proto

generate-proto: $(BUF)
	$(info $(_bullet) Generating <proto>)
	$(BUF) generate

lint: lint-proto

lint-proto: $(BUF)
	$(info $(_bullet) Linting <proto>)
	$(BUF) lint

endif