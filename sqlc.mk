ifndef include_sqlc_mk
_include_sqlc_mk := 1

include makefiles/go.mk

SQLC_VERSION ?= v1.10.0
SQLC_ROOT := $(BUILD)/sqlc-$(SQLC_VERSION)
SQLC := $(SQLC_ROOT)/sqlc

$(SQLC): export GOBIN := $(abspath $(SQLC_ROOT))

$(SQLC):
	$(info $(_bullet) Installing <sqlc>)
	@mkdir -p $(SQLC_ROOT)
	go install github.com/kyleconroy/sqlc/cmd/sqlc@$(SQLC_VERSION)

.PHONY: generate generate-sqlc

generate: generate-sqlc

generate-sqlc: export PATH := "$(SQLC_ROOT):$(PATH)"

generate-sqlc: $(SQLC) ## Generate SQLC code
	$(info $(_bullet) Generating <sqlc>)
	sqlc generate

endif