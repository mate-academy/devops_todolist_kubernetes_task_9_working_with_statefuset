# Validation

1. Create the cluster and deploy resources:

```bash
./bootstrap.sh
```

2. Confirm namespaces and resources exist:

```bash
kubectl get ns
kubectl -n mysql get statefulset,svc,pods
kubectl -n todoapp get deploy,svc,pods
```

3. Verify the MySQL init script ran:

```bash
MYSQL_ROOT_PASSWORD=$(kubectl -n mysql get secret mysql-secret -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}' | base64 -d)
kubectl -n mysql exec -it mysql-0 -- mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "USE todoapp; SHOW TABLES; SELECT COUNT(*) FROM init_check;"
```

4. Validate the app is reachable (NodePort 30007):

```bash
curl -I http://localhost:30007/
```
