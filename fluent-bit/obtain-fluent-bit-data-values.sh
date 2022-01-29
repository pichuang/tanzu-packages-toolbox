#!/bin/bash

image_url=$(kubectl -n tanzu-package-repo-global get packages fluent-bit.tanzu.vmware.com.1.7.5+vmware.1-tkg.1 -o jsonpath='{.spec.template.spec.fetch[0].imgpkgBundle.image}')
echo $image_url

imgpkg pull -b $image_url -o /tmp/fluent-bit.tanzu.vmware.com.1.7.5+vmware.1-tkg.1

cp /tmp/fluent-bit.tanzu.vmware.com.1.7.5+vmware.1-tkg.1/config/values.yaml fluent-bit-data-values.yaml
