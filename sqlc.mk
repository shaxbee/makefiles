ifndef include_sqlc_mk
_include_sqlc_mk := 1

include makefiles/go.mk

SQLC_VERSION ?= v1.11.0
SQLC_ROOT := $(BUILD)/sqlc-$(SQLC_VERSION)
SQLC := $(SQLC_ROOT)/sqlc

$(SQLC): export GOBIN = $(abspath $(SQLC_ROOT))

$(SQLC):
	$(info $(_bullet) Installing <sqlc>)
	@mkdir -p $(SQLC_ROOT)
	go install github.com/kyleconroy/sqlc/cmd/sqlc@$(SQLC_VERSION)

.PHONY: generate generate-sqlc

tools: tools-sqlc

generate: generate-sqlc

.PHONY: tools-sqlc generate-sqlc

tools-sqlc: $(SQLC)

generate-sqlc: $(SQLC)
	$(info $(_bullet) Generating <sqlc>)
	$(SQLC) generate

endif