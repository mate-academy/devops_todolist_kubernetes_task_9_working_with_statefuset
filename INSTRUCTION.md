# Validation Instructions

This document describes how to deploy and validate the MySQL `StatefulSet` and
the ToDo application that connects to it.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## 1. Deploy everything

From the repository root run:

```bash
./bootstrap.sh
```

This creates a `kind` cluster from `cluster.yml`, deploys the MySQL
`StatefulSet` into the `mysql` namespace, then deploys the ToDo app into the
`todoapp` namespace.

## 2. Verify the StatefulSet

```bash
# 3 pods, named predictably mysql-0, mysql-1, mysql-2, created in order
kubectl get statefulset,pods -n mysql -o wide

# Each pod gets its own PVC from the volumeClaimTemplates
kubectl get pvc -n mysql

# The headless Service exposes the pods (CLUSTER-IP should be None)
kubectl get svc mysql -n mysql
```

Expected output: `statefulset.apps/mysql` shows `READY 3/3`, and pods
`mysql-0`, `mysql-1`, `mysql-2` are all `Running`/`Ready`.

### Confirm the requirements

```bash
# Replicas + namespace
kubectl get statefulset mysql -n mysql -o jsonpath='{.spec.replicas}{"\n"}'

# Sensitive values are read from the Secret (not hardcoded)
kubectl describe statefulset mysql -n mysql | grep -A1 -E 'MYSQL_ROOT_PASSWORD|MYSQL_USER|MYSQL_PASSWORD'

# Probes are configured
kubectl get statefulset mysql -n mysql -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}{"\n"}{.spec.template.spec.containers[0].readinessProbe}{"\n"}'

# Requests/limits are configured
kubectl get statefulset mysql -n mysql -o jsonpath='{.spec.template.spec.containers[0].resources}{"\n"}'
```

## 3. Verify stable DNS and the init.sql database

```bash
# Resolve the stable per-pod DNS name of the 0-indexed pod
kubectl run -n mysql dns-test --image=busybox:1.36 --rm -it --restart=Never -- \
  nslookup mysql-0.mysql.mysql.svc.cluster.local

# Confirm init.sql ran: the `tododb` database should exist
kubectl exec -n mysql mysql-0 -- \
  sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"'
```

Expected: the database list includes `tododb`.

## 4. Verify the application connects to mysql-0

```bash
# App pod should be Running and Ready (readiness probe hits /api/ready,
# which requires a working DB connection)
kubectl get pods -n todoapp

# Confirm the DB connection env vars are injected from db-secret
kubectl describe deployment todoapp -n todoapp | grep -A1 -E 'NAME|USER|PASSWORD|HOST'

# Tail the logs — there should be no database connection errors
kubectl logs -n todoapp deployment/todoapp
```

## 5. Open the app

The app is exposed via a NodePort mapped to the host in `cluster.yml`:

```
http://localhost:30007/
```

Create a ToDo item, then confirm it was persisted to MySQL:

```bash
kubectl exec -n mysql mysql-0 -- \
  sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" tododb -e "SHOW TABLES;"'
```

## 6. (Optional) Verify ordered scaling

```bash
# Scaling down removes pods in reverse ordinal order (mysql-2 first)
kubectl scale statefulset mysql -n mysql --replicas=1
kubectl get pods -n mysql -w

# Scale back up
kubectl scale statefulset mysql -n mysql --replicas=3
```

## Cleanup

```bash
kind delete cluster --name todoapp
```
