# Validation instructions

## Prerequisites

`docker`, `kind` and `kubectl` installed, Docker running.

## Deploy

From the repository root:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The script creates the kind cluster, the `mysql` and `todoapp` namespaces, the MySQL StatefulSet (3 replicas) and then the ToDo app.

## Validate

1. **MySQL pods** – all 3 should be `Running` and `1/1 Ready`:
   ```bash
   kubectl get pods -n mysql
   ```
2. **Headless service** – `CLUSTER-IP` must be `None`:
   ```bash
   kubectl get svc -n mysql
   ```
3. **Persistent volumes** – one PVC per MySQL pod (`data-mysql-0..2`), plus `pvc-data` for the app, all `Bound`:
   ```bash
   kubectl get pvc -A
   ```
4. **init.sql was applied** – the `counter` table must exist in `app_db`:
   ```bash
   kubectl exec -n mysql mysql-0 -- mysql -uapp_user -p1234 -e "SHOW TABLES;" app_db
   ```
5. **App pods** – should be `Running` and `1/1 Ready`:
   ```bash
   kubectl get pods -n todoapp
   ```
6. **App connects to `mysql-0`** – check the connection settings and that the app has no DB errors:
   ```bash
   kubectl get secret app-secret -n todoapp -o jsonpath='{.data.HOST}' | base64 -d; echo
   kubectl logs -n todoapp deploy/todoapp
   ```
   Expected host: `mysql-0.mysql.mysql.svc.cluster.local`.
7. **Open the app** at <http://localhost:30007> (NodePort `30007`), or use port-forward:
   ```bash
   kubectl port-forward -n todoapp svc/todoapp-service 8080:80
   ```
   then open <http://localhost:8080>. Create a to-do item and check it is saved.
8. **Data persists in MySQL** – restart the app and verify the item is still there:
   ```bash
   kubectl rollout restart deployment/todoapp -n todoapp
   ```

## Clean up

```bash
kind delete cluster
```
