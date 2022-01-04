ifndef include_skaffold_mk
_include_skaffold_mk := 1

include makefiles/shared.mk
include makefiles/kubectl.mk

SKAFFOLD_VERSION ?= 1.32.0
SKAFFOLD_ROOT := $(BUILD)/skaffold-$(SKAFFOLD_VERSION)
SKAFFOLD := $(SKAFFOLD_ROOT)/skaffold

$(SKAFFOLD):
	$(info $(_bullet) Installing <skaffold>)
	@mkdir -p $(SKAFFOLD_ROOT)
	curl -sSfL https://storage.googleapis.com/skaffold/releases/v$(SKAFFOLD_VERSION)/skaffold-$(OS)-$(ARCH) -o $(SKAFFOLD)
	chmod u+x $(SKAFFOLD)
	ln -s $(subst $(BUILD)/,,$(SKAFFOLD)) $(BUILD)/skaffold

tools: $(SKAFFOLD)

deploy: deploy-skaffold

.PHONY: clean-skaffold build-skaffold deploy-skaffold run-skaffold dev-skaffold debug-skaffold

clean-skaffold build-skaffold deploy-skaffold run-skaffold dev-skaffold debug-skaffold: $(SKAFFOLD) $(KUBECTL)

clean-skaffold: ## Clean Skaffold
	$(info $(_bullet) Cleaning <skaffold>)
	! kubectl config current-context &>/dev/null || \
	skaffold delete

build-skaffold: ## Build artifacts with Skaffold
	$(info $(_bullet) Building artifacts with <skaffold>)
	skaffold build

deploy-skaffold: build-skaffold ## Deploy artifacts with Skaffold
	$(info $(_bullet) Deploying with <skaffold>)
	skaffold build -q | $(SKAFFOLD) deploy --force --build-artifacts -

run-skaffold: ## Run with Skaffold
	$(info $(_bullet) Running stack with <skaffold>)
	skaffold run --force

dev-skaffold: ## Run in development mode with Skaffold
	$(info $(_bullet) Running stack in development mode with <skaffold>)
	skaffold dev --force --port-forward

debug-skaffold: ## Run in debugging mode with Skaffold
	$(info $(_bullet) Running stack in debugging mode with <skaffold>)
	skaffold debug --force --port-forward

endif
