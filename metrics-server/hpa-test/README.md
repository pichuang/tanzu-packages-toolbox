
1. 安裝測試用檔案
```bash
$ kubectl apply -f https://k8s.io/examples/application/php-apache.yaml

deployment.apps/php-apache created
service/php-apache created
```

2. 設定 HPA
```bash
$ kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

horizontalpodautoscaler.autoscaling/php-apache autoscaled

$ kubectl get hpa

NAME         REFERENCE               TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   0%/50%    1         10        1          62s

```

3. 增加負載
```bash
$ kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

If you don't see a command prompt, try pressing enter.
OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!OK!

$ kubectl get hpa
NAME         REFERENCE               TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   138%/50%   1         10        1          116s

$ kubectl get deployment php-apache -w
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
php-apache   6/6     6            6           4m33s
```

4. 
