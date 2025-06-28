.PHONY: gitops-infra-mgt-setup gitops-infra-mgt-teardown
gitops-infra-mgt-setup:
	$(call gitops_apply,k8s/infrastructure/management)
gitops-infra-mgt-teardown:
	$(call gitops_delete,k8s/infrastructure/management)

.PHONY: gitops-infra-ops-setup gitops-infra-ops-teardown
gitops-infra-ops-setup:
	$(call gitops_apply,k8s/infrastructure/operations)
gitops-infra-ops-teardown:
	$(call gitops_delete,k8s/infrastructure/operations)

.PHONY: gitops-infra-setup gitops-infra-teardown
gitops-infra-setup:
	$(call gitops_apply,k8s/infrastructure)
gitops-infra-teardown:
	$(call gitops_delete,k8s/infrastructure)

.PHONY: gitops-setup gitops-teardown
gitops-setup:
	# kubectl apply -f k8s/application.yaml
	$(call gitops_apply,k8s/)
gitops-teardown:
	kubectl delete -f k8s/application.yaml
	$(call gitops_delete,k8s/)

.PHONY: gitops-dev-mgt-setup gitops-dev-mgt-teardown
gitops-dev-mgt-setup:
	$(call gitops_apply,k8s/development/management)
gitops-dev-mgt-teardown:
	$(call gitops_delete,k8s/development/management)

define gitops_apply
	kustomize build --enable-helm $(1) | kubectl apply -f -
endef

define gitops_delete
	kustomize build --enable-helm $(1) | kubectl delete -f -
endef