# Kubernetes deployment and validation

This project runs a Django ToDo application and MySQL in a local `kind`
cluster. MySQL runs as a three-replica StatefulSet in the `mysql` namespace.
The application in the `todoapp` namespace connects to `mysql-0`.

## Requirements

- Docker
- `kind`
- `kubectl`
- At least 3 GB of memory available to Docker

## Deploy

From the repository root, run:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The script creates the `kind` cluster if needed, builds and loads the
application image, creates the MySQL ConfigMap from
`.infrastructure/init.sql`, and deploys MySQL and the application.

The credentials in the Secret manifests are for this local exercise only.
Do not reuse them outside this project.

## Validate MySQL

```bash
kubectl get pods -n mysql
kubectl get statefulset,service,pvc -n mysql
kubectl get secret mysql-secrets -n mysql
```

Expected:

- `mysql-0`, `mysql-1`, and `mysql-2` are Running and Ready.
- StatefulSet `mysql` is `3/3`.
- Service `mysql` has `CLUSTER-IP` set to `None` (headless).
- PVCs `data-mysql-0`, `data-mysql-1`, and `data-mysql-2` are Bound.

Check that `init.sql` created the database table:

```bash
kubectl exec -n mysql mysql-0 -- \
  mysql -uapp_user -p1234 app_db -e "SHOW TABLES;"
```

Expected output includes the `counter` table.

## Validate the application

```bash
kubectl get pods,service -n todoapp
kubectl logs -n todoapp deployment/todoapp
```

Confirm Django is using MySQL and can connect:

```bash
kubectl exec -n todoapp deployment/todoapp -- \
  python manage.py shell -c \
  'from django.db import connection; connection.ensure_connection(); print(connection.vendor)'
```

Expected output: `mysql`.

Check migrations:

```bash
kubectl exec -n todoapp deployment/todoapp -- python manage.py showmigrations
```

The application is exposed on the kind NodePort configured in `cluster.yml`:

```bash
curl -i http://localhost:30007/
```

Probe endpoints can be checked inside the Pod:

```bash
kubectl exec -n todoapp deployment/todoapp -- \
  python -c "from urllib.request import urlopen; print(urlopen('http://127.0.0.1:8080/api/health/').status)"
kubectl exec -n todoapp deployment/todoapp -- \
  python -c "from urllib.request import urlopen; print(urlopen('http://127.0.0.1:8080/api/ready/').status)"
```

Both should return `200` after startup.

## Troubleshooting

```bash
kubectl describe pod -n mysql mysql-0
kubectl logs -n mysql mysql-0
kubectl describe pod -n todoapp -l app=todoapp
kubectl logs -n todoapp deployment/todoapp
```

Rerun `./bootstrap.sh` after changing manifests or application code.

## Cleanup

This deletes the local cluster and all data stored in it:

```bash
kind delete cluster --name kind
```