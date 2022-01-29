#!/bin/bash

image_url=$(kubectl -n tanzu-package-repo-global get packages pinniped.tanzu.vmware.com.0.4.4+vmware.1-tkg.1 -o jsonpath='{.spec.template.spec.fetch[0].imgpkgBundle.image}')
echo $image_url

imgpkg pull -b $image_url -o /tmp/pinniped.tanzu.vmware.com.0.4.4+vmware.1-tkg.1

cp /tmp/pinniped.tanzu.vmware.com.0.4.4+vmware.1-tkg.1/config/values.yaml pinniped-data-values.yaml
