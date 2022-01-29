# 安裝 vsphere-csi

## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list vsphere-csi.tanzu.vmware.com -A
```

- Output
```
- Retrieving package versions for vsphere-csi.tanzu.vmware.com...
  NAME                          VERSION               RELEASED-AT                    NAMESPACE
  vsphere-csi.tanzu.vmware.com  2.3.0+vmware.1-tkg.2  2021-08-30 23:42:12 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 vsphere-csi
- Input
```bash
tanzu package install vsphere-csi \
    --package-name vsphere-csi.tanzu.vmware.com \
    --version 2.3.0+vmware.1-tkg.2 \
    --namespace tanzu-package-repo-global \
    --values-file vsphere-csi-data-values.yaml \
    --create-namespace
```

- Output
```bash
Error: package reconciliation failed: ytt: Error: Evaluating starlark template:
- assert.fail: fail: vsphereCSI clusterName should be provided
    in validate_vsphereCSI
      6 |    data.values.vsphereCSI.clusterName or assert.fail("vsphereCSI clusterName should be provided")
    in <toplevel>
      18 | validate_vsphereCSI()
```

## Step 3: 安裝後檢查 vsphere-csi
- Input
```bash
kubectl get all -n kube-system
```

- Output
```
```

## (Optioanl) 移除 vsphere-csi
```bash
tanzu package installed delete vsphere-csi -n tanzu-package-repo-global
```