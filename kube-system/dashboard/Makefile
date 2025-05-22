.DEFAULT_GOAL := deploy

DOMAIN_NAME  ?= dashboard.k8s.localhost
NAMESPACE    ?= kubernetes-dashboard
HUB_PROVIDES ?=

#ifneq (,$(filter tls-ingress,$(HUB_PROVIDES)))
	INGRESS:=ingress-tls
#else
#	INGRESS:=ingress
#endif
INGRESS:=treafik

kubectl ?= kubectl --context="$(DOMAIN_NAME)" --namespace="$(NAMESPACE)"

deploy:
	-$(kubectl) create ns $(NAMESPACE)
	-$(kubectl) apply -f service-account.yaml
	-$(kubectl) apply -f rbac-$(RBAC_KIND).yaml
	-$(kubectl) apply -f secret.yaml
	-$(kubectl) apply -f configmap.yaml
	-$(kubectl) apply -f deployment.yaml
	-$(kubectl) apply -f service.yaml
	-$(kubectl) apply -f $(INGRESS).yaml

undeploy:
	-$(kubectl) delete -f $(INGRESS).yaml
	-$(kubectl) delete -f service.yaml
	-$(kubectl) delete -f deployment.yaml
	-$(kubectl) delete -f configmap.yaml
	-$(kubectl) delete -f secret.yaml
	-$(kubectl) delete -f rbac-$(RBAC_KIND).yaml
	-$(kubectl) delete -f service-account.yaml

k8s-get-admin-user-token:
	kubectl get -n kube-system -o json secrets \
		| jq -r '.items[] | select (.metadata.annotations."kubernetes.io/service-account.name"=="admin-user") | .data.token' \
		| base64 -d