TOOLS_MAKE := $(shell pwd)/tools/make
include $(TOOLS_MAKE)/argocd.mk
include $(TOOLS_MAKE)/gitops.mk
include $(TOOLS_MAKE)/k3d.mk
