# 安裝 Fluent-bit

## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list fluent-bit.tanzu.vmware.com -A
```

- Output
```
- Retrieving package versions for fluent-bit.tanzu.vmware.com...
  NAME                         VERSION               RELEASED-AT                    NAMESPACE
  fluent-bit.tanzu.vmware.com  1.7.5+vmware.1-tkg.1  2021-05-14 02:00:00 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 Fluent-bit
- Input
```bash
tanzu package install fluent-bit \
    --package-name fluent-bit.tanzu.vmware.com \
    --version 1.7.5+vmware.1-tkg.1 \
    --namespace tanzu-package-repo-global \
    --values-file fluent-bit-data-values.yaml \
    --create-namespace
```

- Output
```bash
/ Installing package 'fluent-bit.tanzu.vmware.com'
| Creating namespace 'tanzu-package-repo-global'
| Getting package metadata for 'fluent-bit.tanzu.vmware.com'
| Creating service account 'fluent-bit-tanzu-package-repo-global-sa'
| Creating cluster admin role 'fluent-bit-tanzu-package-repo-global-cluster-role'
| Creating cluster role binding 'fluent-bit-tanzu-package-repo-global-cluster-rolebinding'
| Creating secret 'fluent-bit-tanzu-package-repo-global-values'
- Creating package resource
| Package install status: Reconciling

 Added installed package 'fluent-bit' in namespace 'tanzu-package-repo-global'
```

## Step 3: 安裝後檢查 Fluent-bit
- Input
```bash
kubectl get all -n tanzu-system-logging
```

- Output
```
NAME                   READY   STATUS    RESTARTS   AGE
pod/fluent-bit-glx8w   1/1     Running   0          84s
pod/fluent-bit-lzbsc   1/1     Running   0          84s
pod/fluent-bit-xfgsf   1/1     Running   0          84s

NAME                        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/fluent-bit   3         3         3       3            3           <none>          84s
```

## (Optioanl) 移除 fluent-bit
```bash
tanzu package installed delete fluent-bit -n tanzu-package-repo-global
```