# 安裝 contour

## Step 0: 要先有 contour.tanzu.vmware.com

## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list contour.tanzu.vmware.com -A
```

- Output
```
| Retrieving package versions for contour.tanzu.vmware.com...
  NAME                      VERSION                RELEASED-AT                    NAMESPACE
  contour.tanzu.vmware.com  1.17.1+vmware.1-tkg.1  2021-07-24 02:00:00 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 contour
- Input
```bash
tanzu package install contour \
    --package-name contour.tanzu.vmware.com \
    --version 1.17.1+vmware.1-tkg.1 \
    --namespace tanzu-package-repo-global \
    --values-file contour-data-values.yaml \
    --create-namespace
```

- Error Output
```
Error: package reconciliation failed: kapp: Error: Expected to find kind 'cert-manager.io/v1alpha2/Issuer', but did not:
- Kubernetes API server did not have matching apiVersion + kind
- No matching CRD was found in given configuration
```

- Output
```
| Installing package 'contour.tanzu.vmware.com'
| Creating namespace 'tanzu-package-repo-global'
| Getting package metadata for 'contour.tanzu.vmware.com'
| Creating service account 'contour-tanzu-package-repo-global-sa'
| Creating cluster admin role 'contour-tanzu-package-repo-global-cluster-role'
| Creating cluster role binding 'contour-tanzu-package-repo-global-cluster-rolebinding'
| Creating secret 'contour-tanzu-package-repo-global-values'
- Creating package resource
/ Package install status: Reconciling

 Added installed package 'contour' in namespace 'tanzu-package-repo-global'
```

## Step 2: 更新 contour
- Input
```bash
tanzu package installed update contour \
    --version 1.17.1+vmware.1-tkg.1 \
    --namespace tanzu-package-repo-global \
    --values-file contour-data-values.yaml
```


## Step 3: 安裝後檢查 contour
- Input
```bash
kubectl get all -n tanzu-system-ingress
```

- Output
```
NAME                                              READY   STATUS    RESTARTS   AGE
NAME                           READY   STATUS    RESTARTS   AGE
pod/contour-5866d5dfcf-ngj7r   1/1     Running   0          94s
pod/contour-5866d5dfcf-zd786   1/1     Running   0          94s
pod/envoy-cl9kg                2/2     Running   0          94s
pod/envoy-hwj84                2/2     Running   0          94s

NAME              TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
service/contour   ClusterIP   20.20.29.0    <none>        8001/TCP                     94s
service/envoy     NodePort    20.20.62.84   <none>        80:32188/TCP,443:30832/TCP   94s

NAME                   DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/envoy   2         2         2       2            2           <none>          94s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/contour   2/2     2            2           94s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/contour-5866d5dfcf   2         2         2       94s
```

## (Optional) Access the Envoy Administration Interface Remotely
```
ENVOY_POD=$(kubectl -n tanzu-system-ingress get pod -l app=envoy -o name | head -1)
kubectl -n tanzu-system-ingress port-forward $ENVOY_POD 9001

# Open Browser
Open http://127.0.0.1:9001
```

## (Optional) Visualize the Internal Contour Directed Acyclic Graph (DAG)
```bash
CONTOUR_POD=$(kubectl -n tanzu-system-ingress get pod -l app=contour -o name | head -1)
kubectl -n tanzu-system-ingress port-forward $CONTOUR_POD 6060

# Open New Terminal
curl localhost:6060/debug/dag | dot -T png > contour-dag.png
```


## 測試
```
$ kubectl get svc -owide -n tanzu-system-ingress

NAME      TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE     SELECTOR
contour   ClusterIP   20.20.29.0    <none>        8001/TCP                     5m47s   app=contour,kapp.k14s.io/app=1643446395365820179
envoy     NodePort    20.20.62.84   <none>        80:32188/TCP,443:30832/TCP   5m47s   app=envoy,kapp.k14s.io/app=1643446395365820179

$ kubectl get nodes -owide
NAME                  STATUS   ROLES    AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                                     KERNEL-VERSION       CONTAINER-RUNTIME
tanzu-control-plane   Ready    master   92m   v1.19.1   172.16.217.132   <none>        Ubuntu Groovy Gorilla (development branch)   4.19.191-4.ph3-esx   containerd://1.4.0
tanzu-worker          Ready    <none>   91m   v1.19.1   172.16.217.131   <none>        Ubuntu Groovy Gorilla (development branch)   4.19.191-4.ph3-esx   containerd://1.4.0
tanzu-worker2         Ready    <none>   91m   v1.19.1   172.16.217.133   <none>        Ubuntu Groovy Gorilla (development branch)   4.19.191-4.ph3-esx   containerd://1.4.0

$ kubectl create ns kuard
namespace/kuard created

$ kubectl apply -f kuard-app.yaml -n kuard
deployment.apps/kuard created
service/kuard created
ingress.networking.k8s.io/kuard created

$ kubectl get pod,service,deployment,ingress -n kuard
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
NAME                         READY   STATUS    RESTARTS   AGE
pod/kuard-798585497b-7m2ql   1/1     Running   0          46s
pod/kuard-798585497b-hb5q4   1/1     Running   0          46s
pod/kuard-798585497b-hrwgj   1/1     Running   0          46s

NAME            TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kuard   ClusterIP   20.20.35.2   <none>        80/TCP    46s

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kuard   3/3     3            3           46s

NAME                       CLASS    HOSTS                      ADDRESS   PORTS     AGE
ingress.extensions/kuard   <none>   kuard.hphil.vmware.local             80, 443   46s

$ curl 172.16.217.131:80
$ curl 172.16.217.133:80

```

- [Ingress, SSL and DNS using TKG 1.4 Packages on TKGs Clusters](https://www.definit.co.uk/2021/12/ingress-ssl-and-dns-using-tkg-1.4-packages-on-tkgs-clusters/)


## (Optioanl) 移除 contour
```bash
tanzu package installed delete contour -n tanzu-package-repo-global
```