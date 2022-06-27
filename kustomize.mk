ifndef _include_kustomize_mk
_include_kustomize_mk := 1

include makefiles/shared.mk

KUSTOMIZE_VERSION ?= v4.5.5
KUSTOMIZE_ROOT := $(BUILD)/kustomize-$(KUSTOMIZE_VERSION)
KUSTOMIZE := $(KUSTOMIZE_ROOT)/kustomize

$(KUSTOMIZE):
	$(info $(_bullet) Installing <kustomize>)
	@mkdir -p $(KUSTOMIZE_ROOT)
	curl -sSfL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/$(KUSTOMIZE_VERSION)/kustomize_$(KUSTOMIZE_VERSION)_$(OS)_$(ARCH).tar.gz -o $(KUSTOMIZE).tar.gz
	tar xf $(KUSTOMIZE).tar.gz -C $(KUSTOMIZE_ROOT)
	rm $(KUSTOMIZE).tar.gz
	chmod u+x $(KUSTOMIZE)
	ln -sf $(subst $(BUILD)/,,$(KUSTOMIZE)) $(BUILD)/kustomize

tools: $(KUSTOMIZE)

endif
