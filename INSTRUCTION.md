Execute the bootstrap script:

```bash
./bootstrap.sh
```
Validate Namespace and StatefulSet Replicas:

```bash
kubectl get statefulset,pods -n mysql
```

B. Validate Headless Service
```bash
kubectl get svc mysql -n mysql
kubectl get endpoints mysql -n mysql
```

C. Validate Persistent Volume Claims
```bash
kubectl get pvc -n mysql
```

D. Validate Database Initialization
```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u app_user -p1234 -e "SHOW DATABASES;"
```

