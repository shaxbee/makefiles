ifndef _include_kind_mk
_include_kind_mk := 1
_kind_mk_path := $(dir $(lastword $(MAKEFILE_LIST)))

include makefiles/shared.mk
include makefiles/kubectl.mk

KIND_VERSION ?= v0.14.0
KIND_ROOT := $(BUILD)/kind-$(KIND_VERSION)
KIND := $(KIND_ROOT)/kind

KIND_CLUSTER_NAME ?= local
KIND_K8S_VERSION ?= v1.21.1
KIND_HOST_PORT ?= 80

BOOTSTRAP_CONTEXT := kind-$(KIND_CLUSTER_NAME)

$(KIND):
	$(info $(_bullet) Installing <kind>)
	@mkdir -p $(KIND_ROOT)
	curl -sSfL https://kind.sigs.k8s.io/dl/$(KIND_VERSION)/kind-$(OS)-$(ARCH) -o $(KIND)
	chmod u+x $(KIND)
	ln -sf $(subst $(BUILD)/,,$(KIND)) $(BUILD)/kind

tools: $(KIND)

clean-bin: clean-kind

clean: clean-kind

bootstrap: bootstrap-kind

.PHONY: clean-kind bootstrap-kind

clean-kind bootstrap-kind: export CLUSTER_NAME := $(KIND_CLUSTER_NAME)
clean-kind bootstrap-kind: export K8S_VERSION := $(KIND_K8S_VERSION:v%=%)
clean-kind bootstrap-kind: export HOST_PORT := $(KIND_HOST_PORT)

clean-kind: $(KIND) # Delete cluster
	$(info $(_bullet) Cleaning <kind>)
	$(dir $(_kind_mk_path))scripts/bootstrap-kind

bootstrap-kind: $(KUBECTL) $(KIND)
	$(info $(_bullet) Bootstraping <kind>)
	$(dir $(_kind_mk_path))scripts/clean-kind

endif