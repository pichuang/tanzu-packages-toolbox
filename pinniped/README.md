# 安裝 pinniped

## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list pinniped.tanzu.vmware.com -A
```

- Output
```
- Retrieving package versions for pinniped.tanzu.vmware.com...
  NAME                       VERSION               RELEASED-AT                    NAMESPACE
  pinniped.tanzu.vmware.com  0.4.4+vmware.1-tkg.1  2021-08-30 23:42:12 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 pinniped
- Input
```bash
tanzu package install pinniped \
    --package-name pinniped.tanzu.vmware.com \
    --version 0.4.4+vmware.1-tkg.1 \
    --namespace tanzu-package-repo-global \
    --values-file pinniped-data-values.yaml \
    --create-namespace
```

- Error Output
```bash
Error: package reconciliation failed: ytt: Error: Evaluating starlark template:
- assert.fail: fail: tkg_cluster_role must be provided to be either 'management' or 'workload'
    in validate_pinniped
      10 |   data.values.tkg_cluster_role in ("management", "workload") or assert.fail("tkg_cluster_role must be provided to be either 'management' or 'workload'")
    in <toplevel>
      150 | validate_pinniped()

Error: package reconciliation failed: ytt: Error: Evaluating starlark template:
- assert.fail: fail: infrastructure_provider must be provided to be either 'vsphere', 'azure' or 'aws'
    in validate_pinniped
      11 |   data.values.infrastructure_provider in ("vsphere", "azure", "aws") or assert.fail("infrastructure_provider must be provided to be either 'vsphere', 'azure' or 'aws'")
    in <toplevel>
      150 | validate_pinniped()
```

- Output
```
- Installing package 'pinniped.tanzu.vmware.com'
| Creating namespace 'tanzu-package-repo-global'
| Getting package metadata for 'pinniped.tanzu.vmware.com'
| Creating service account 'pinniped-tanzu-package-repo-global-sa'
| Creating cluster admin role 'pinniped-tanzu-package-repo-global-cluster-role'
| Creating cluster role binding 'pinniped-tanzu-package-repo-global-cluster-rolebinding'
| Creating secret 'pinniped-tanzu-package-repo-global-values'
- Creating package resource
| Package install status: Reconciling

Please consider using 'tanzu package installed update' to update the installed package with correct settings
```



## Step 3: 安裝後檢查 pinniped
- Input
```bash
kubectl get all -n pinniped-concierge
kubectl get all -n pinniped-supervisor
```

- Output
```
NAME                                              READY   STATUS    RESTARTS   AGE
pod/pinniped-concierge-7d6b7df67-dvldg            1/1     Running   0          109s
pod/pinniped-concierge-7d6b7df67-pbkbl            1/1     Running   0          109s
pod/pinniped-concierge-kube-cert-agent-a9124c96   1/1     Running   0          70s

NAME                             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/pinniped-concierge-api   ClusterIP   20.20.158.7   <none>        443/TCP   109s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/pinniped-concierge   2/2     2            2           109s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/pinniped-concierge-7d6b7df67   2         2         2       109s
NAME                                 READY   STATUS   RESTARTS   AGE
pod/pinniped-post-deploy-job-ckgp6   0/1     Error    0          76s
pod/pinniped-post-deploy-job-dq7bj   0/1     Error    0          36s
pod/pinniped-post-deploy-job-hs9fd   0/1     Error    0          96s
pod/pinniped-post-deploy-job-sjv5c   0/1     Error    0          106s
pod/pinniped-post-deploy-job-zr5jb   0/1     Error    0          112s

NAME                                 COMPLETIONS   DURATION   AGE
job.batch/pinniped-post-deploy-job   0/1           113s       113s
```

## (Optioanl) 移除 pinniped
```bash
tanzu package installed delete pinniped -n tanzu-package-repo-global
```