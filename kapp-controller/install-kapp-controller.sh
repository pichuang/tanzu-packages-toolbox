#!/bin/bash

REPOSITORY_NAMESPACE="tanzu-package-repo-global"

kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
echo "Waiting 60 sec"
sleep 60

kubectl create ns $REPOSITORY_NAMESPACE
tanzu package repository add tanzu-standard -n $REPOSITORY_NAMESPACE --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0
#tanzu package repository add tanzu-standard --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0
tanzu package repository add tanzu-core -n $REPOSITORY_NAMESPACE --url projects.registry.vmware.com/tkg/packages/core/repo:v1.21.2_vmware.1-tkg.1
#tanzu package repository add tanzu-core --url projects.registry.vmware.com/tkg/packages/core/repo:v1.21.2_vmware.1-tkg.1

echo "Waiting 60 sec"
sleep 60
tanzu package repository list -n $REPOSITORY_NAMESPACE
#tanzu package repository list

echo "Waiting 60 sec"
sleep 60
tanzu package available list -n $REPOSITORY_NAMESPACE
#tanzu package available list
