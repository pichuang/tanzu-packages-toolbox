#!/bin/bash

image_url=$(kubectl -n tanzu-package-repo-global get packages vsphere-csi.tanzu.vmware.com.2.3.0+vmware.1-tkg.2 -o jsonpath='{.spec.template.spec.fetch[0].imgpkgBundle.image}')
echo $image_url

imgpkg pull -b $image_url -o /tmp/vsphere-csi.tanzu.vmware.com.2.3.0+vmware.1-tkg.2

cp /tmp/vsphere-csi.tanzu.vmware.com.2.3.0+vmware.1-tkg.2/config/values.yaml vsphere-csi-data-values.yaml
