ifndef _include_kubectl_mk
_include_kubectl_mk := 1

include makefiles/shared.mk

KUBECTL_VERSION ?= v1.21.4
KUBECTL_ROOT := $(BUILD)/kubectl-$(KUBECTL_VERSION)
KUBECTL := $(KUBECTL_ROOT)/kubectl

$(KUBECTL):
	$(info $(_bullet) Installing <kubectl>)
	@mkdir -p $(KUBECTL_ROOT)
	curl -sSfL https://storage.googleapis.com/kubernetes-release/release/$(KUBECTL_VERSION)/bin/$(OS)/$(ARCH)/kubectl -o $(KUBECTL)
	chmod u+x $(KUBECTL)
	ln -sf $(subst $(BUILD)/,,$(KUBECTL)) $(BUILD)/kubectl

tools: $(KUBECTL)

endif

