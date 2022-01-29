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
```

## Step 2: 安裝 cert-manager
- Input
```bash
tanzu package install cert-manager \
    --package-name cert-manager.tanzu.vmware.com \
    --version 1.1.0+vmware.1-tkg.2 \
    --namespace tanzu-package-repo-global \
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
kubectl get all -n cert-manager
```

- Output
```
NAME                                          READY   STATUS    RESTARTS   AGE
pod/cert-manager-79447db547-6xg8z             1/1     Running   0          77s
pod/cert-manager-cainjector-684d954df-9jnfb   1/1     Running   0          77s
pod/cert-manager-webhook-cfcc6c8f-bdz7l       1/1     Running   0          77s

NAME                           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/cert-manager           ClusterIP   10.105.211.59    <none>        9402/TCP   77s
service/cert-manager-webhook   ClusterIP   10.111.163.223   <none>        443/TCP    77s

NAME                                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/cert-manager              1/1     1            1           77s
deployment.apps/cert-manager-cainjector   1/1     1            1           77s
deployment.apps/cert-manager-webhook      1/1     1            1           77s

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/cert-manager-79447db547             1         1         1       78s
replicaset.apps/cert-manager-cainjector-684d954df   1         1         1       78s
replicaset.apps/cert-manager-webhook-cfcc6c8f       1         1         1       78s
```

## (Optional): 新建自簽 CA
```bash
openssl genrsa -des3 -out localRootCA.key 2048
cat opensslv3.cnf
openssl req -x509 -new -nodes -key localRootCA.key -reqexts v3_req -extensions v3_ca -config opensslv3.cnf -sha256 -days 1825 -out localRootCA.pem
openssl rsa -in localRootCA.key -out localca.selfsign.key
ls -la
```

- Output:
```
-rw-r--r--  1 pichuang  staff  4037 Jan 28 22:39 README.md
-rw-r--r--  1 pichuang  staff  1751 Jan 28 22:24 localRootCA.key
-rw-r--r--  1 pichuang  staff  1566 Jan 28 22:31 localRootCA.pem
-rw-r--r--  1 pichuang  staff  1679 Jan 28 22:38 localca.selfsign.key
-rw-r--r--  1 pichuang  staff   541 Jan 28 22:31 opensslv3.cnf
```

- [Securely Connect with Your Local Kubernetes Environment](https://tanzu.vmware.com/developer/blog/securely-connect-with-your-local-kubernetes-environment/)
- [Ingress, SSL and DNS using TKG 1.4 Packages on TKGs Clusters](https://www.definit.co.uk/2021/12/ingress-ssl-and-dns-using-tkg-1.4-packages-on-tkgs-clusters/)

## Step 4: 將憑證放入 Cert-manager
- Input:
```bash
kubectl create secret tls local-ca-secret \
    --key localca.selfsign.key \
    --cert localRootCA.pem \
    -n cert-manager

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: localca-issuer
  namespace: cert-manager
spec:
  ca:
    secretName: local-ca-secret
EOF
```

- Output
```
secret/local-ca-secret created
clusterissuer.cert-manager.io/localca-issuer created
```

## (Optional) 移除 cert-manager
```bash
tanzu package installed delete cert-manager -n vmw-kapp
```