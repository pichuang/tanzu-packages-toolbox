#!/bin/bash
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
tanzu package repository add tanzu-standard --url projects.registry.vmware.com/tkg/packages/standard/repo:v1.4.0
tanzu package repository add tanzu-core --url projects.registry.vmware.com/tkg/packages/core/repo:v1.21.2_vmware.1-tkg.1
tanzu package repository list
tanzu package available list
