# 安裝 Grafana

## Step 0: 需要先安裝 contour.tanzu.vmware.com
```
kapp: Error: Expected to find kind 'projectcontour.io/v1/HTTPProxy', but did not:
- Kubernetes API server did not have matching apiVersion + kind
- No matching CRD was found in given configuration
```

## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list grafana.tanzu.vmware.com -A
```

- Output
```
- Retrieving package versions for grafana.tanzu.vmware.com...
  NAME                      VERSION               RELEASED-AT                    NAMESPACE
  grafana.tanzu.vmware.com  7.5.7+vmware.1-tkg.1  2021-05-20 02:00:00 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 Grafana
- Input
```bash
tanzu package install grafana \
    --package-name grafana.tanzu.vmware.com \
    --version 7.5.7+vmware.1-tkg.1 \
    --namespace tanzu-package-repo-global \
    --values-file grafana-data-values.yaml \
    --create-namespace
```

- Output
```bash

```

## (Optioanl) 移除 Grafana
```bash
tanzu package installed delete grafana -n tanzu-package-repo-global
```