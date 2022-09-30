ifndef _include_buf_mk
_include_buf_mk := 1

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

.PHONY: generate generate-buf lint lint-buf

generate: generate-buf

generate-buf: $(BUF)
	$(info $(_bullet) Generating <buf>)
	buf generate

lint: lint-buf

lint-buf: $(BUF)
	$(info $(_bullet) Linting <buf>)
	buf lint

endif