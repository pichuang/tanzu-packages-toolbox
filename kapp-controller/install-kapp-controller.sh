#!/bin/bash

REPOSITORY_NAMESPACE="tanzu-package-repo-global"

# Online kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml

kubectl apply -f tanzu-system-kapp-ctrl-restricted.yaml
kubectl apply -f kapp-controller.yaml
kubectl get pods -n tkg-system | grep kapp-controller

echo "Waiting 60 sec"
sleep 60

kubectl create ns tanzu-package-repo-global
kubectl create ns tkg-system
tanzu package repository add tanzu-standard -n tanzu-package-repo-global --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.5.2
tanzu package repository add tanzu-core -n tkg-system --url projects.registry.vmware.com/tkg/packages/core/repo:v1.21.8_vmware.1-tkg.5

echo "Waiting 60 sec"
sleep 60
tanzu package repository list -n tanzu-package-repo-global

echo "Waiting 60 sec"
sleep 60
tanzu package available list -n tkg-system
