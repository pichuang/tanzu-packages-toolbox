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

## (Optional) 測試 Prometheus Service in tanzu-system-monitoring
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

## (Optioanl) 移除 prometheus
```bash
tanzu package installed delete grafana -n tanzu-package-repo-global
```