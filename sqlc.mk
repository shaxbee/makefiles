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
	ln -sf $(subst $(BUILD)/,,$(SQLC)) $(BUILD)/sqlc

tools: $(SQLC)

generate: generate-sqlc

.PHONY: generate-sqlc

generate-sqlc: $(SQLC)
	$(info $(_bullet) Generating <sqlc>)
	sqlc generate

endif