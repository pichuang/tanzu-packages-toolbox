# 安裝 Prometheus
## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list prometheus.tanzu.vmware.com -A
```

- Output
```
- Retrieving package versions for prometheus.tanzu.vmware.com...
  NAME                         VERSION                RELEASED-AT                    NAMESPACE
  prometheus.tanzu.vmware.com  2.27.0+vmware.1-tkg.1  2021-05-13 02:00:00 +0800 CST  tanzu-package-repo-global
  prometheus.tanzu.vmware.com  2.27.0+vmware.2-tkg.1  2021-05-13 02:00:00 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 prometheus
- Input
```bash
tanzu package install prometheus \
    --package-name prometheus.tanzu.vmware.com \
    --version  2.27.0+vmware.2-tkg.1 \
    --namespace tanzu-system-monitoring \
    --create-namespace
```
- https://github.com/vmware-tanzu/community-edition/tree/main/addons/packages/prometheus/2.27.0

- Output
```bash

```

## Step 3: 安裝後檢查 prometheus
- Input
```bash
kubectl get all -n tanzu-system-monitoring
```

- Output
```
NAME                                                 READY   STATUS    RESTARTS   AGE
pod/alertmanager-7c5f9d9d6c-f7hkd                    1/1     Running   0          2m17s
pod/prometheus-cadvisor-6p8rd                        1/1     Running   0          2m17s
pod/prometheus-cadvisor-9xk68                        1/1     Running   0          2m17s
pod/prometheus-kube-state-metrics-7bbc89cbb8-55cfs   1/1     Running   0          2m17s
pod/prometheus-node-exporter-2rxh8                   1/1     Running   0          2m18s
pod/prometheus-node-exporter-cckg7                   1/1     Running   0          2m18s
pod/prometheus-node-exporter-jr7k9                   1/1     Running   0          2m18s
pod/prometheus-pushgateway-64f6d4f674-96rn2          1/1     Running   0          2m17s
pod/prometheus-server-7b6985bbcf-fw6h4               2/2     Running   0          2m18s

NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
service/alertmanager                    ClusterIP   20.20.154.159   <none>        80/TCP          2m17s
service/prometheus-kube-state-metrics   ClusterIP   None            <none>        80/TCP,81/TCP   2m18s
service/prometheus-node-exporter        ClusterIP   20.20.175.79    <none>        9100/TCP        2m17s
service/prometheus-pushgateway          ClusterIP   20.20.149.26    <none>        9091/TCP        2m18s
service/prometheus-server               ClusterIP   20.20.248.126   <none>        80/TCP          2m17s

NAME                                      DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/prometheus-cadvisor        2         2         2       2            2           <none>          2m17s
daemonset.apps/prometheus-node-exporter   3         3         3       3            3           <none>          2m18s

NAME                                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/alertmanager                    1/1     1            1           2m17s
deployment.apps/prometheus-kube-state-metrics   1/1     1            1           2m17s
deployment.apps/prometheus-pushgateway          1/1     1            1           2m18s
deployment.apps/prometheus-server               1/1     1            1           2m18s

NAME                                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/alertmanager-7c5f9d9d6c                    1         1         1       2m17s
replicaset.apps/prometheus-kube-state-metrics-7bbc89cbb8   1         1         1       2m17s
replicaset.apps/prometheus-pushgateway-64f6d4f674          1         1         1       2m18s
replicaset.apps/prometheus-server-7b6985bbcf               1         1         1       2m18s
```

## 測試 Prometheus Service in tanzu-system-monitoring
```bash
# 開啟一個 debug-container
$ kubectl run -n tanzu-system-monitoring debug-container --rm -i --tty --image docker.io/nicolaka/netshoot -- /bin/bash

# 檢查 pushgateway
bash-5.1$ curl -o /dev/null -s -w "%{http_code}\n" --insecure prometheus-pushgateway.tanzu-system-monitoring:9091
200

# 檢查 node exporter
bash-5.1$ curl -o /dev/null -s -w "%{http_code}\n" --insecure prometheus-node-exporter.tanzu-system-monitoring:9100
200

# 檢查 alertmanager
bash-5.1$ curl -o /dev/null -s -w "%{http_code}\n" --insecure alertmanager.tanzu-system-monitoring:80
200

# 檢查 prometheus-server
bash-5.1$ curl prometheus-server.tanzu-system-monitoring:80
<a href="/graph">Found</a>.
```


## Debug
```bash
kubectl get pods alertmanager-59fd7b5d7d-ckzxm
kubectl debug -it alertmanager-6d54cd84b6-7bcb5 --image=busybox --share-processes --copy-to=some-app-debug
```


- https://towardsdatascience.com/the-easiest-way-to-debug-kubernetes-workloads-ff2ff5e3cc75

## (Optioanl) 移除 prometheus
```bash
tanzu package installed delete prometheus -n tanzu-package-repo-global
```


## Q&A
### Q1
```bash
level=error ts=2022-02-19T19:13:06.126Z caller=main.go:246 msg="unable to initialize gossip mesh" err="create memberlist: Failed to get final advertise address: No private IP address found, and explicit IP not provided"
```

A1:
https://www.796t.com/article.php?id=420380

```
--cluster.advertise-address=0.0.0.0:9093
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

## Scrape Configs
- [etcd](https://etcd.io/docs/v3.5/op-guide/monitoring/#prometheus)
  - grafana https://grafana.com/grafana/dashboards/3070
- [contour](https://projectcontour.io/guides/prometheus/)
- [harbor](https://goharbor.io/docs/2.4.0/administration/metrics/)
- [fluentbit](https://hulining.gitbook.io/fluentbit/administration/monitoring)


