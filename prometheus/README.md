# 安裝 Prometheus
## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list prometheus.tanzu.vmware.com -A
```

- Output
```
\ Retrieving package versions for prometheus.tanzu.vmware.com...
  NAME                         VERSION                RELEASED-AT                    NAMESPACE
  prometheus.tanzu.vmware.com  2.27.0+vmware.1-tkg.1  2021-05-13 02:00:00 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 prometheus
- Input
```bash
tanzu package install prometheus \
    --package-name prometheus.tanzu.vmware.com \
    --version 2.27.0+vmware.1-tkg.1 \
    --namespace vmw-kapp \
    --create-namespace
```

- Output
```bash

```

## Step 3: 安裝後檢查 prometheus
- Input
```bash

```

- Output
```
```

## (Optioanl) 移除 prometheus
```bash
tanzu package installed delete prometheus -n vmw-kapp
```


## 版本資訊
PACKAGE-VERSION: 2.27.0+vmware.1-tkg.1

```
$ prometheus --version
prometheus, version 2.27.0 (branch: non-git, revision: non-git)
  build user:       root@cfa440a118e0
  build date:       20210812-21:55:42
  go version:       go1.16.6
  platform:         linux/amd64

$ alertmanager, version  (branch: , revision: )
  build user:
  build date:
  go version:       go1.14.15
  platform:         linux/amd64

$ pushgateway --version
pushgateway, version  (branch: , revision: )
  build user:
  build date:
  go version:       go1.14.15
  platform:         linux/amd64

$ node_exporter --version
node_exporter, version  (branch: , revision: )
  build user:
  build date:
  go version:       go1.14.15
  platform:         linux/amd64

```

https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.4/vmware-tanzu-kubernetes-grid-14/GUID-packages-prometheus.html#review-configuration-parameters-9

