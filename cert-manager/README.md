# 安裝 cert-manager
## Step 1: 確認 Package Version
- Input
```bash
tanzu package available list cert-manager.tanzu.vmware.com -A
```

- Output
```
- Retrieving package versions for cert-manager.tanzu.vmware.com...
  NAME                           VERSION               RELEASED-AT                    NAMESPACE
  cert-manager.tanzu.vmware.com  1.1.0+vmware.1-tkg.2  2020-11-25 02:00:00 +0800 CST  tanzu-package-repo-global
  cert-manager.tanzu.vmware.com  1.1.0+vmware.2-tkg.1  2020-11-25 02:00:00 +0800 CST  tanzu-package-repo-global
  cert-manager.tanzu.vmware.com  1.5.3+vmware.2-tkg.1  2021-08-24 01:22:51 +0800 CST  tanzu-package-repo-global
```

## Step 2: 安裝 cert-manager
- Input
```bash
tanzu package install cert-manager \
    --package-name cert-manager.tanzu.vmware.com \
    --version 1.5.3+vmware.2-tkg.1 \
    --namespace cert-manager \
    --create-namespace
```

- Output
```bash
- Installing package 'cert-manager.tanzu.vmware.com'
| Creating namespace 'tanzu-package-repo-global'
| Getting package metadata for 'cert-manager.tanzu.vmware.com'
| Creating service account 'cert-manager-tanzu-package-repo-global-sa'
| Creating cluster admin role 'cert-manager-tanzu-package-repo-global-cluster-role'
| Creating cluster role binding 'cert-manager-tanzu-package-repo-global-cluster-rolebinding'
- Creating package resource
| Package install status: Reconciling

 Added installed package 'cert-manager' in namespace 'tanzu-package-repo-global'
```

## Step 3: 安裝後檢查 cert-manager
- Input
```bash
watch -n 5 kubectl get all -n cert-manager
```

- Output
```
NAME                                           READY   STATUS    RESTARTS   AGE
pod/cert-manager-74d6564cf5-hq8rl              1/1     Running   0          105s
pod/cert-manager-cainjector-5987766855-qnrhb   1/1     Running   0          105s
pod/cert-manager-webhook-5f7696554d-p59xk      1/1     Running   0          105s

NAME                           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/cert-manager           ClusterIP   100.100.152.52   <none>        9402/TCP   8m32s
service/cert-manager-webhook   ClusterIP   100.97.129.171   <none>        443/TCP    8m32s

NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/cert-manager              1/1     1            1           8m32s
deployment.apps/cert-manager-cainjector   1/1     1            1           8m32s
deployment.apps/cert-manager-webhook      1/1     1            1           8m32s

NAME                                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/cert-manager-548c458c5f              0         0         0       8m32s
replicaset.apps/cert-manager-74d6564cf5              1         1         1       105s
replicaset.apps/cert-manager-cainjector-5987766855   1         1         1       105s
replicaset.apps/cert-manager-cainjector-89bc86db5    0         0         0       8m32s
replicaset.apps/cert-manager-webhook-5f7696554d      1         1         1       105s
replicaset.apps/cert-manager-webhook-8647bc58c       0         0         0       8m32s
```

## 自建 Issuer
```bash
$ cat secret-ca-key-pair.yml
apiVersion: v1
kind: Secret
metadata:
  name: ca-key-pair
  namespace: cert-manager
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZYekNDQkVlZ0F3SUJBZ0lKQU4yU2FRdkpkNFZWTUEwR0NTcUdTSWIzRFFFQkN3VUFNSUhMTVFzd0NRWUQKVlFRR0V3SlVWekVQTUEwR0ExVUVDQXdHVkdGcGNHVnBNUlF3RWdZRFZRUUhEQXRVWVdsd1pXa2dRMmwwZVRFVwpNQlFHQTFVRUNnd05WazEzWVhKbElGUmhhWGRoYmpFek1ERUdBMVVFQ3d3cVRXOWtaWEp1SUVGd2NHeHBZMkYwCmFXOXVJRkJzWVhSbWIzSnRjeUJDZFhOcGJtVnpjeUJWYm1sME1TY3dKUVlEVlFRRERCNVVZVzU2ZFNCRVpYWmwKYkc5d1pYSWdRMlZ1ZEdWeUlGSnZiM1FnUTBFeEh6QWRCZ2txaGtpRzl3MEJDUUVXRUdod2FHbHNRSFp0ZDJGeQpaUzVqYjIwd0hoY05Nakl3TWpFNU1UVTFNVE0zV2hjTk16SXdNakUzTVRVMU1UTTNXakNCeXpFTE1Ba0dBMVVFCkJoTUNWRmN4RHpBTkJnTlZCQWdNQmxSaGFYQmxhVEVVTUJJR0ExVUVCd3dMVkdGcGNHVnBJRU5wZEhreEZqQVUKQmdOVkJBb01EVlpOZDJGeVpTQlVZV2wzWVc0eE16QXhCZ05WQkFzTUtrMXZaR1Z5YmlCQmNIQnNhV05oZEdsdgpiaUJRYkdGMFptOXliWE1nUW5WemFXNWxjM01nVlc1cGRERW5NQ1VHQTFVRUF3d2VWR0Z1ZW5VZ1JHVjJaV3h2CmNHVnlJRU5sYm5SbGNpQlNiMjkwSUVOQk1SOHdIUVlKS29aSWh2Y05BUWtCRmhCb2NHaHBiRUIyYlhkaGNtVXUKWTI5dE1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBMFFYU2dZUTcveUJVU3dTZApTL2t6aDFlU1FFVzQrY0N5enJTbWJIMGJtZlIrUEp3MGxBWEtWMjFLV3ZRcDN6ZEtDT0ljcDhoeHlSRHpHSU5VCnY4VlgxQWtqYUlqd3VPS2lGczg4Q25valRnYnZFODgvWU9WanJsTkYyNGp0eDdNMndEYlk1SndpWXM2OCsrVVAKOEIyLzcrVVhxUkphV1dNcnpsZUJFc0VmQUtEVEdrU2g3YUdZdys5RE5IRXZqVWRldGtWajdSUXhOVzZIaVBSZQpSSzFjRURRVnU3Z01vS2gxd0J5NGlRL04xRXI3WElzWmJjbWNKZExReGx2UVdoMDhmRGpDNlVEQ25MM1BKanQwCnVOQWVMSTE2SHNaNVNCRU9vS0gzeDFxWitKMmtULzRHWFhxNHM1cVNVMmE3QXZWTkY5MjNnR3d3clNuRWhsMjYKQUVOdXpRSURBUUFCbzRJQlFqQ0NBVDR3SFFZRFZSME9CQllFRktzWDRKTGhacHFJY0dBR20xV3VxOUZQaU1rRApNSUlCQUFZRFZSMGpCSUg0TUlIMWdCU3JGK0NTNFdhYWlIQmdCcHRWcnF2UlQ0akpBNkdCMGFTQnpqQ0J5ekVMCk1Ba0dBMVVFQmhNQ1ZGY3hEekFOQmdOVkJBZ01CbFJoYVhCbGFURVVNQklHQTFVRUJ3d0xWR0ZwY0dWcElFTnAKZEhreEZqQVVCZ05WQkFvTURWWk5kMkZ5WlNCVVlXbDNZVzR4TXpBeEJnTlZCQXNNS2sxdlpHVnliaUJCY0hCcwphV05oZEdsdmJpQlFiR0YwWm05eWJYTWdRblZ6YVc1bGMzTWdWVzVwZERFbk1DVUdBMVVFQXd3ZVZHRnVlblVnClJHVjJaV3h2Y0dWeUlFTmxiblJsY2lCU2IyOTBJRU5CTVI4d0hRWUpLb1pJaHZjTkFRa0JGaEJvY0docGJFQjIKYlhkaGNtVXVZMjl0Z2drQTNaSnBDOGwzaFZVd0RBWURWUjBUQkFVd0F3RUIvekFMQmdOVkhROEVCQU1DQVFZdwpEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRURCQVl6YlczcEhJeHpSRmtiZGtyNU9Fc3VMQ1o4aGE1WWkzeDJ1ClRGczBzTDJIbWNsQ0p1Q2YzaXY2Mmdpb2ZtbUI2ZUtkNHFMSHhsNEtVN2JxcGZvcjlLanZESUVDUFl5NlNvSXcKdlpwbnhJWldSUXhQdkZGREFhUmNxVWIyVmxHZGphTzVobVdPZ21LTjlPWEpGb3NXazlPcHk1eURTcStRUjllMwpib1JtTFF4eWxkeE5oMWVUT1cyVHIrbXBHNkQ2UlRwRWZFcDNlQ05jbXA0T281YU9MRnF6STh3Ti8xU09YZmNwCndIaWlzYWZwY2lKK2FTWkdwNzlIT29MalJxaE9FYTN2NFh0Mi9JWk0wNkhvOUY0Y25oaGdsU09KTXB3S0ptaHYKdnVadjF0dkh6YW5OS0I5YnpBTXpDV0JWNjI1VEhtRkxONEdyUjlLaFVVVlQ3cUk9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBMFFYU2dZUTcveUJVU3dTZFMva3poMWVTUUVXNCtjQ3l6clNtYkgwYm1mUitQSncwCmxBWEtWMjFLV3ZRcDN6ZEtDT0ljcDhoeHlSRHpHSU5VdjhWWDFBa2phSWp3dU9LaUZzODhDbm9qVGdidkU4OC8KWU9WanJsTkYyNGp0eDdNMndEYlk1SndpWXM2OCsrVVA4QjIvNytVWHFSSmFXV01yemxlQkVzRWZBS0RUR2tTaAo3YUdZdys5RE5IRXZqVWRldGtWajdSUXhOVzZIaVBSZVJLMWNFRFFWdTdnTW9LaDF3Qnk0aVEvTjFFcjdYSXNaCmJjbWNKZExReGx2UVdoMDhmRGpDNlVEQ25MM1BKanQwdU5BZUxJMTZIc1o1U0JFT29LSDN4MXFaK0oya1QvNEcKWFhxNHM1cVNVMmE3QXZWTkY5MjNnR3d3clNuRWhsMjZBRU51elFJREFRQUJBb0lCQVFDc1YzU2R2WDRLZVltRwo0U01neFRRclg1VUMwWG9XMHorYkYzQXcrMmFLcGdCLzBQdTVJSjBaUU0rUjlzZWZlR0xldURDUVZzRWEyNUxVCm4xUjlXaVYwZXFSclNKM1NrMnE2Qzl5aGR0c3ROcUpoWHZ3TzFKUS81QUV4WmRGSVd3ZkZySE5nNnl1ZTlINzEKNG9RbG95SGlscTNQaFlaaE5WZWxKcGtSOFpHeVhXanBIcktWTjVWKys5dTdOZHk5Wiswb0RhZ0ZRQXo5Y0pvNApOc0tqV3dDTVBrRUIrbFpXWkkvaXk1bXMvZUVBT2dxbHFqTjlMV01jT2RpMjlsd0ZvSDh5b3hzUStRRTRJQ0xWCi84azJEVzBDcVFRcm9iMjNkdXJWU3pvVHVweEp5cHN2bzA2K2JJYjJTUlBwYi9kVnIxaHJSZ3FVRmlham0rRVYKaklCcm9aMHhBb0dCQVA4UlpGUXhMdEhtdGlaR2JFam9sUlRBdFI0UWNZZHNLUXpHK2hvemd0QjdxekVEZTF5MQo4NjJmcGdHUTFmZGRIVkc2TzVnclVJN0d1VG01bDR2cGNTSlRuQmdLcXdMcGxxUUdoK1BQdGI0OE83bE44dXFvCkp2OVdPaTh3bGQ5UG5pdG1LSFIrbENjZ1JtNzNFMWh0UmVienQyWS93bDdyTmtGT0g5aUUrQVZEQW9HQkFOSEoKVzBZVW9nYXRQQVM4RHZ1V1FNMWNaTWdUSXQ3YjZUWkVjaXVKQ2NmVHJ0TjVTWVBhbGF4bjBHeGcybEdUYXp6UwpsNHh4ZkFhc28rS1ZBVVgweXFDVDBuQy9tZEFSU3JTS29DOEJJM1RYTG4zK2FXM01CeFNyNmY2R3lrTTIzWWNUCjM0dWI0SFhINzBGUEorUHpacG5PYlBseUZSV1NrRDlhRDRBQUlIS3ZBb0dBYVhQd1RkcVRwOVpCb210bEkzTjkKQnpwdzV3QVhYOHk0My81M3NsTnZsdkE2STZaejN5MmVsRDYzN0ZmTURsdmgza01ubGs3NkhEMU9vTzM1R0xBbgp4UEJhVFpwRGY0M0JhUWtHTDRwVmNsUUd3U0xYOW1vVXpXWUI0amF0RDhrajlIOWs1RnpjdFp4allrY21LVjNzCkU0TFpaUjJoSjRzSlFGQ2pXK29GZkc4Q2dZRUFuOU1neDNabXJtR0NiVFQ4MFMxNmR6b2h5Yy9TYkNqc05welUKd2xnbjdHWllOZUtjWUdqQ1NOUGFsUWNBck05OERwMStPZEFucGtvV25VUFo4WHI2ZUhYR0NJSGdaQVVZZmcxeQoxZnl2RDQvMGFxYk5tWW1zQjFLbDlYU3BXYVhPQmQvZEdsYUtIaEZSTk5kaVU2Y1hEcXlXbDBBVDBoaVQ3ci9sCk9TWmZraDhDZ1lFQXl2WnRrUEVQYnk5MkNBbVgwUnRmV1FvOFNDdUY0RG1ZZnBqTVRMTmlOMDV0dk96ZFgrRUYKVlIwSnltN050ZFZCVlA2SHh3c2hxblIxdUtUd1dycis0Ry9Ua2wrNWtrNFgrQTRjdlllUEg2SVFtTlJ1a2lqRAowVzFYOUFPVE1BOTcxNWVNbkprU09GcTBDM1V4U1VkcGdJRXdLK0Y2cFlneVlwMkJpajd2WDg0PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=

$ cat clusterissuer-localhost-ca.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ca-issuer
  namespace: cert-manager
spec:
  ca:
    secretName: ca-key-pair

$ kubectl get clusterissuers ca-issuer -o wide
NAME        READY   STATUS                AGE
ca-issuer   True    Signing CA verified   22m
```

## create a CA certificate that references the self-signed Issuer and specifies the isCA field.

```bash
$ cat certificate-tanzu-developer-center.yaml
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
 name: wildcard-tanzu-local-ca
 namespace: cert-manager
spec:
 secretName: certificate-tanzu-developer-center
 isCA: true
 issuerRef:
   name: ca-issuer
   kind: ClusterIssuer
 commonName: "Tanzu Developer Center Certificate"
 dnsNames:
 - "www.example.com"
 - "fallback.bar.com"
 - "*.projectcontour.io"
 - "*.tanzu.local"

$ kubectl apply -f certificate-tanzu-developer-center.yaml
$ kubectl get Certificate -owide
NAME                      READY   SECRET                               ISSUER      STATUS                                          AGE
wildcard-tanzu-local-ca   True    certificate-tanzu-developer-center   ca-issuer   Certificate is up to date and has not expired   45s


# 下面不用弄
$ cat tanzu-local-issuer.yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
 name: tanzu-local-tls
 namespace: cert-manager
spec:
 ca:
   secretName: certificate-tanzu-developer-center

$ kubectl get Issuer -owide
NAME                READY   STATUS                AGE
tanzu-local-tls     True    Signing CA verified   19s
```


## (Optional) 移除 cert-manager
```bash
tanzu package installed delete cert-manager -n vmw-kapp
```


- [Securely Connect with Your Local Kubernetes Environment](https://tanzu.vmware.com/developer/blog/securely-connect-with-your-local-kubernetes-environment/)
- [Ingress, SSL and DNS using TKG 1.4 Packages on TKGs Clusters](https://www.definit.co.uk/2021/12/ingress-ssl-and-dns-using-tkg-1.4-packages-on-tkgs-clusters/)
- [Creating your own self-signed and CA Issuers](https://www.ibm.com/docs/en/cpfs?topic=manager-creating-your-own-self-signed-ca-issuers)
- [使用certManager自动管理https证书](https://juejin.cn/post/7046722328008327198)