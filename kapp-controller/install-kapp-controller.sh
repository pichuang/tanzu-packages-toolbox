#!/bin/bash

REPOSITORY_NAMESPACE="tanzu-package-repo-global"

#kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml

kubectl apply -f tanzu-system-kapp-ctrl-restricted.yaml
kubectl apply -f kapp-controller.yaml
kubectl get pods -n tkg-system | grep kapp-controller

echo "Waiting 60 sec"
sleep 60

kubectl create ns $REPOSITORY_NAMESPACE
tanzu package repository add tanzu-standard -n $REPOSITORY_NAMESPACE --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0
tanzu package repository add tanzu-core -n $REPOSITORY_NAMESPACE --url projects.registry.vmware.com/tkg/packages/core/repo:v1.21.2_vmware.1-tkg.1

echo "Waiting 60 sec"
sleep 60
tanzu package repository list -n $REPOSITORY_NAMESPACE

echo "Waiting 60 sec"
sleep 60
tanzu package available list -n $REPOSITORY_NAMESPACE
