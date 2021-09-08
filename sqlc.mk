ifndef include_sqlc_mk
_include_sqlc_mk := 1

include makefiles/go.mk

SQLC := bin/sqlc
SQLC_VERSION ?= v1.7.0

$(SQLC): $(BIN)
	$(info $(_bullet) Installing <sqlc>)
	GOBIN=$(BIN) go install github.com/kyleconroy/sqlc/cmd/sqlc@$(SQLC_VERSION)

.PHONY: generate generate-sqlc

generate: generate-sqlc

generate-sqlc: $(SQLC) ## Generate SQLC code
	$(info $(_bullet) Generating <sqlc>)
	$(SQLC) generate

endif