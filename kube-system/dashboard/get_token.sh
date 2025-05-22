#!/bin/bash
#cluster-admin
#admin-user
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep cluster-admin | awk '{print $1}')
#kubectl get -n kube-system -o json secrets \
#	| jq -r '.items[] | select (.metadata.annotations."kubernetes.io/service-account.name"=="admin-user") | .data.token' \
#	| base64 -d