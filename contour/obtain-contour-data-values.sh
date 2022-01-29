#!/bin/bash

image_url=$(kubectl -n tanzu-package-repo-global get packages contour.tanzu.vmware.com.1.17.1+vmware.1-tkg.1 -o jsonpath='{.spec.template.spec.fetch[0].imgpkgBundle.image}')
echo $image_url

imgpkg pull -b $image_url -o /tmp/contour.tanzu.vmware.com.1.17.1+vmware.1-tkg.1

cp /tmp/contour.tanzu.vmware.com.1.17.1+vmware.1-tkg.1/config/values.yaml contour-data-values.yaml
