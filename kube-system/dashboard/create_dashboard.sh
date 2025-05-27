#!/bin/bash
kubectl apply -f service-account.yaml
kubectl apply -f rbac-read-only.yaml
kubectl apply -f secret.yaml
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress-treafik.yaml
./get_token.sh

# https://github.com/Marcel-Lambacher/Masterloft.git