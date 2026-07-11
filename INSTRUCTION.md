# Validation Instructions

This document explains how to stand up the cluster and verify that the
ToDo app and its MySQL backend are working correctly.

## Prerequisites

- Docker
- [`kind`](https://kind.sigs.k8s.io/)
- `kubectl`

## 1. Create the cluster

From the repo root:

```bash
kind create cluster --config cluster.yml --name todoapp-cluster
```

Confirm the nodes are up:

```bash
kubectl get nodes
```

You should see 1 control-plane node and 2 worker nodes, all `Ready`.

## 2. Deploy everything

Run the bootstrap script (it applies namespaces, MySQL StatefulSet,
app config/secrets, storage, the Deployment, HPA, and Services in the
correct order, and waits for rollouts to finish):

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## 3. Validate the MySQL StatefulSet

Check that all 3 replicas are running, named predictably (`mysql-0`,
`mysql-1`, `mysql-2`):

```bash
kubectl get pods -n mysql -l app=mysql
```

Expected: `mysql-0`, `mysql-1`, `mysql-2` all `Running` / `1/1 Ready`.

Check the headless service and its endpoints:

```bash
kubectl get svc mysql-headless -n mysql
kubectl get endpoints mysql-headless -n mysql
```

Check that persistent storage was provisioned per pod via the
`volumeClaimTemplates`:

```bash
kubectl get pvc -n mysql
```

Expected: one PVC per pod (`mysql-data-mysql-0`, `mysql-data-mysql-1`,
`mysql-data-mysql-2`).

Confirm the `init.sql` script ran and the database/user exist by
exec-ing into `mysql-0`:

```bash
kubectl exec -it mysql-0 -n mysql -- \
  mysql -u root -p"$(kubectl get secret mysql-secret -n mysql -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}' | base64 -d)" \
  -e "SHOW DATABASES; SELECT User, Host FROM mysql.user WHERE User='todouser';"
```

Expected: a `todoapp` database is listed, and the `todouser` account exists.

Check liveness/readiness probes are passing (pods should show `1/1`
ready and no restarts unless something failed):

```bash
kubectl describe pod mysql-0 -n mysql
```

## 4. Validate the application Deployment

Check pods are running and connected to `mysql-0`:

```bash
kubectl get pods -n todoapp -l app=todoapp
kubectl logs -n todoapp -l app=todoapp
```

Expected: no database connection errors in the logs, and the app
reports it connected to `mysql-0.mysql-headless.mysql.svc.cluster.local`.

Verify the app secret used for DB connection is correctly consumed:

```bash
kubectl exec -it -n todoapp deploy/todoapp -- env | grep DB_
```

Expected: `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST` are all set
and `DB_HOST` points at `mysql-0.mysql-headless.mysql.svc.cluster.local`.

## 5. Validate connectivity end-to-end

Hit the app through the NodePort service (port `30007`, mapped to the
host via `cluster.yml`):

```bash
curl http://localhost:30007/api/health
curl http://localhost:30007/api/ready
```

Both should return a healthy/ready response, confirming the app can
reach MySQL and respond to requests.

Optionally, exercise the API to confirm data is actually persisted
in MySQL (create a to-do item, then query MySQL directly to confirm
the row exists):

```bash
curl -X POST http://localhost:30007/api/todos/ -d '{"title": "test item"}' -H "Content-Type: application/json"

kubectl exec -it mysql-0 -n mysql -- \
  mysql -u todouser -p"$(kubectl get secret mysql-secret -n mysql -o jsonpath='{.data.MYSQL_PASSWORD}' | base64 -d)" \
  -e "USE todoapp; SHOW TABLES;"
```

## 6. Validate scaling (HPA)

```bash
kubectl get hpa -n todoapp
```

Expected: the `todoapp` HPA shows current/target CPU & memory
utilization, with `minReplicas: 2` and `maxReplicas: 5`.

## 7. Tear down

```bash
kind delete cluster --name todoapp-cluster
```

## Files added/changed for this task

| File | Purpose |
|---|---|
| `mysql-namespace.yml` | Creates the `mysql` namespace |
| `mysql-secret.yml` | `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD` |
| `mysql-init-configmap.yml` | `init.sql`, mounted at `/docker-entrypoint-initdb.d` |
| `mysql-headless-service.yml` | Headless `Service` (`clusterIP: None`) exposing MySQL pods for stable DNS (`mysql-0.mysql-headless.mysql.svc.cluster.local`) |
| `mysql-statefulset.yml` | 3-replica `StatefulSet` with liveness/readiness probes, resource requests/limits, and `volumeClaimTemplates` |
| `db-secret.yml` | App-facing DB connection secret (`NAME`, `USER`, `PASSWORD`, `HOST`) in the `todoapp` namespace |
| `deployment.yml` | Updated to read `DB_NAME`/`DB_USER`/`DB_PASSWORD`/`DB_HOST` from `db-secret` so the app connects to `mysql-0` |
| `bootstrap.sh` | Applies every manifest in the correct dependency order and waits for rollouts |
