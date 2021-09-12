ifndef _include_kubectl_mk
_include_kubectl_mk := 1

include makefiles/shared.mk

KUBECTL := $(BIN)/kubectl
KUBECTL_VERSION ?= v1.21.4

$(KUBECTL): | $(BIN)
	$(info $(_bullet) Installing <kubectl>)
	curl -sSfL https://storage.googleapis.com/kubernetes-release/release/$(KUBECTL_VERSION)/bin/$(OS)/amd64/kubectl -o $(KUBECTL)
	chmod u+x $(KUBECTL)

endif

