#!/bin/bash
# objects created by k8s-dashboard.yaml
kubectl delete secret k8s-dashboard-certs -n kube-system
kubectl delete secret k8s-dashboard-csrf -n kube-system
kubectl delete serviceaccount k8s-dashboard -n kube-system
kubectl delete role k8s-dashboard-minimal -n kube-system
kubectl delete rolebinding k8s-dashboard-minimal -n kube-system
kubectl delete deployment k8s-dashboard -n kube-system
kubectl delete service k8s-dashboard -n kube-system
# objects created by admin service account and role binding
kubectl delete serviceaccount admin-user -n kube-system
kubectl delete clusterrolebinding admin-user -n kube-system