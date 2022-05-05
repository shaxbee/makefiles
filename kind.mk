ifndef _include_kind_mk
_include_kind_mk := 1
_kind_mk_path := $(dir $(lastword $(MAKEFILE_LIST)))

include makefiles/shared.mk
include makefiles/kubectl.mk

KIND_VERSION ?= v0.11.1
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

.PHONY: clean-kind bootstrap-kind bootstrap-hydra

clean-kind bootstrap-kind: export CLUSTER_NAME := $(KIND_CLUSTER_NAME)
clean-kind bootstrap-kind: export K8S_VERSION := $(KIND_K8S_VERSION:v%=%)
clean-kind bootstrap-kind: export HOST_PORT := $(KIND_HOST_PORT)
bootstrap-contour bootstrap-hydra clean-hydra clean-contour: export BOOTSTRAP_CONTEXT := $(BOOTSTRAP_CONTEXT)

clean-kind: $(KIND) # Delete cluster
	$(info $(_bullet) Cleaning <kind>)
	$(dir $(_kind_mk_path))scripts/kind/clean

bootstrap-kind: $(KUBECTL) $(KIND)
	$(info $(_bullet) Bootstraping <kind>)
	$(dir $(_kind_mk_path))scripts/kind/bootstrap

bootstrap-contour: bootstrap-kind
	$(info $(_bullet) Bootstraping <contour>)
	$(dir $(_kind_mk_path))scripts/contour/bootstrap

clean-contour:
	$(info $(_bullet) Cleaning <contour>)
	$(dir $(_kind_mk_path))scripts/contour/clean

bootstrap-hydra: bootstrap-kind
	$(info $(_bullet) Bootstrapping <hydra>)
	$(dir $(_kind_mk_path))scripts/hydra/bootstrap

clean-hydra:
	$(info $(_bullet) Cleaning <hydra>)
	$(dir $(_kind_mk_path))scripts/hydra/clean

endif
