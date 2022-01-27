#!/bin/bash

image_url=$(kubectl -n tanzu-package-repo-global get packages prometheus.tanzu.vmware.com.2.27.0+vmware.1-tkg.1 -o jsonpath='{.spec.template.spec.fetch[0].imgpkgBundle.image}')
echo $image_url

imgpkg pull -b $image_url -o /tmp/prometheus-package-2.27.0+vmware.1-tkg.1

cp /tmp/prometheus-package-2.27.0+vmware.1-tkg.1/config/values.yaml prometheus-data-values.yaml


