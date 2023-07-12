ifndef _include_proto_mk
_include_proto_mk := 1

include makefiles/shared.mk

BUF_VERSION ?= v1.23.1
BUF_ROOT := $(BUILD)/buf-$(BUF_VERSION)
BUF := $(BUF_ROOT)/bin/buf

$(BUF):
	$(info $(_bullet) Installing <buf>)
	@mkdir -p $(BUF_ROOT)
	curl -sSfL "https://github.com/bufbuild/buf/releases/download/$(BUF_VERSION)/buf-$(shell uname -s)-$(shell uname -m).tar.gz" | \
	tar -xzf - -C "$(BUF_ROOT)" --strip-components 1
	ln -sf $(subst $(BUILD)/,,$(BUF)) $(BUILD)/buf

tools: $(BUF)

generate: generate-proto

.PHONY: generate-proto lint lint-proto

generate-proto: $(BUF)
	$(info $(_bullet) Generating <proto>)
	buf generate

lint: lint-proto

lint-proto: $(BUF)
	$(info $(_bullet) Linting <proto>)
	buf lint

endif