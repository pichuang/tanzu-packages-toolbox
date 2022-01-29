#!/bin/bash

image_url=$(kubectl -n tanzu-package-repo-global get packages grafana.tanzu.vmware.com.7.5.7+vmware.1-tkg.1 -o jsonpath='{.spec.template.spec.fetch[0].imgpkgBundle.image}')
echo $image_url

imgpkg pull -b $image_url -o /tmp/grafana.tanzu.vmware.com.7.5.7+vmware.1-tkg.1

cp /tmp/grafana.tanzu.vmware.com.7.5.7+vmware.1-tkg.1/config/values.yaml grafana-data-values.yaml
