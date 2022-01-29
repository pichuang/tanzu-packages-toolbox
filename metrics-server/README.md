# 安裝 metrics-server

## (Optional) 試試看 kubectl top
```bash
kubectl top node
kubectl top pods -n kube-system
```

- Output
```
error: Metrics API not available
error: Metrics API not available
```

## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list metrics-server.tanzu.vmware.com -A
```

- Output
```
/ Retrieving package versions for metrics-server.tanzu.vmware.com...
  NAME                             VERSION               RELEASED-AT                    NAMESPACE
  metrics-server.tanzu.vmware.com  0.4.0+vmware.1-tkg.1  2021-08-30 23:42:12 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 metrics-server
- Input
```bash
tanzu package install metrics-server \
    --package-name metrics-server.tanzu.vmware.com \
    --version 0.4.0+vmware.1-tkg.1 \
    --namespace tanzu-package-repo-global \
    --create-namespace
```

- Output
```
/ Installing package 'metrics-server.tanzu.vmware.com'
| Creating namespace 'tanzu-package-repo-global'
| Getting package metadata for 'metrics-server.tanzu.vmware.com'
| Creating service account 'metrics-server-tanzu-package-repo-global-sa'
| Creating cluster admin role 'metrics-server-tanzu-package-repo-global-cluster-role'
| Creating cluster role binding 'metrics-server-tanzu-package-repo-global-cluster-rolebinding'
- Creating package resource
| Package install status: Reconciling

 Added installed package 'metrics-server' in namespace 'tanzu-package-repo-global'
```

## Step 3: 安裝後檢查 metrics-server
- Input
```bash
kubectl get all -n kube-system | grep metrics-server
```

- Output
```
pod/metrics-server-567d4f6bfb-l9kgx               1/1     Running   0          29s
service/metrics-server   ClusterIP   20.20.205.131   <none>        443/TCP                  29s
deployment.apps/metrics-server   1/1     1            1           29s
replicaset.apps/metrics-server-567d4f6bfb   1         1         1       29s
```

## Step 4: 檢查 kubectl top
- Input
```bash
kubectl top node
kubectl top pods -n kube-system
```

- Output
```
NAME                  CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
tanzu-control-plane   359m         17%    964Mi           48%
tanzu-worker          192m         9%     311Mi           15%
tanzu-worker2         122m         6%     505Mi           25%

NAME                                          CPU(cores)   MEMORY(bytes)
coredns-f9fd979d6-7jnvq                       4m           9Mi
coredns-f9fd979d6-skq5v                       4m           9Mi
etcd-tanzu-control-plane                      34m          32Mi
kindnet-hzdkt                                 2m           8Mi
kindnet-sq2k9                                 1m           4Mi
kindnet-tlprz                                 2m           7Mi
kube-apiserver-tanzu-control-plane            95m          394Mi
kube-controller-manager-tanzu-control-plane   24m          47Mi
kube-proxy-7nqq7                              9m           13Mi
kube-proxy-9d9gm                              1m           15Mi
kube-proxy-nf57f                              8m           14Mi
kube-scheduler-tanzu-control-plane            4m           20Mi
metrics-server-567d4f6bfb-l9kgx               0m           6Mi
```