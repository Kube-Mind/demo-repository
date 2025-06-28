.PHONY: argocd-install argocd-proxy argocd-password argocd-login argocd-clean argocd-wait
ARGOCD_NAMESPACE=argo-cd
ARGOCD_VALUES=./k8s/argo-cd/values.yaml
ARGOCD_PASSWORD=$$(kubectl -n $(ARGOCD_NAMESPACE) get secret argocd-initial-admin-secret -o yaml | grep -o 'password: .*' | sed -e s"/password\: //g" | base64 -d)
argocd-install:
	kustomize build --enable-helm k8s/infrastructure/management/argo-cd | kubectl apply -f -
	$(MAKE) argocd-wait

argocd-clean:
	kustomize build --enable-helm k8s/infrastructure/management/argo-cd | kubectl delete -f -

argocd-wait:
	kubectl -n $(ARGOCD_NAMESPACE) wait -l app.kubernetes.io/name=argocd-server --for=condition=ready pod --timeout=360s

argocd-proxy: argocd-password
	kubectl -n $(ARGOCD_NAMESPACE) port-forward svc/argo-cd-server 8080:80

argocd-password:
	@echo "ARGOCD_PASSWORD: $(ARGOCD_PASSWORD)"

argocd-login: argocd-password
	@argocd login 127.0.0.1:8080 --insecure --username="admin" --password="$(ARGO_PASSWORD)"

argocd-bootstrap: argocd-login
	argocd app create main \
		--dest-namespace $(ARGOCD_NAMESPACE) \
		--dest-server https://kubernetes.default.svc \
		--repo https://gitlab.com/kube-mind/fleet-infra.git \
		--path src/main  
	argocd app sync main