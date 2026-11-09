# ToDo app with MySQL StatefulSet

## What was added

MySQL (`.infrastructure/mysql/`, namespace `mysql`):

- `namespace.yml`: namespace `mysql`.
- `secret.yml`: Secret `mysql-secrets` with `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`.
- `configMap.yml`: ConfigMap `mysql` with `init.sql`, mounted to `/docker-entrypoint-initdb.d`, so MySQL runs it on the first start (creates `app_db` and grants privileges to `app_user`).
- `service.yml`: headless Service `mysql` (`clusterIP: None`). It gives every pod a stable DNS name: `mysql-0.mysql.mysql.svc.cluster.local`, `mysql-1.mysql...`, `mysql-2.mysql...`.
- `statefulSet.yml`: StatefulSet `mysql` with 3 replicas, `mysql:8.0`, credentials from the Secret, `livenessProbe` and `readinessProbe` (`mysqladmin ping`), CPU and memory `requests` and `limits`, and `volumeClaimTemplates` (every pod gets its own 1Gi volume for `/var/lib/mysql`).

ToDo app:

- `src/todolist/settings.py`: the app uses MySQL; connection data is read from the environment variables `NAME`, `USER`, `PASSWORD`, `HOST`.
- `src/requirements.txt`, `src/todolist/__init__.py`: MySQL driver `PyMySQL`.
- `src/Dockerfile`: migrations run when the container starts (the database is available only in the cluster).
- `.infrastructure/db-secret.yml`: Secret `db-secret` with `NAME`, `USER`, `PASSWORD`, `HOST`. `HOST` points to the 0 indexed pod: `mysql-0.mysql.mysql.svc.cluster.local`.
- `.infrastructure/deployment.yml`: new image `kkurama/todoapp:5.0.0`, all keys of `db-secret` are passed to the container with `envFrom`.

### Namespaces

- `mysql` namespace: only the database (StatefulSet, its headless Service, Secret `mysql-secrets`, ConfigMap with `init.sql`). The MySQL volumes are created by `volumeClaimTemplates` in this namespace: `data-mysql-0`, `data-mysql-1`, `data-mysql-2`.
- `todoapp` namespace: the application. `db-secret.yml` is in `todoapp` on purpose: a pod can read Secrets only from its own namespace, and the Deployment lives in `todoapp`.
- The app reaches MySQL across namespaces by the DNS name of the 0 indexed pod: `mysql-0.mysql.mysql.svc.cluster.local` (`<pod>.<headless service>.<namespace>.svc.cluster.local`).

## 1. Create the cluster

```bash
kind create cluster --config cluster.yml
```

## 2. Build and push the app image

```bash
docker build -t kkurama/todoapp:5.0.0 src
docker push kkurama/todoapp:5.0.0
```

## 3. Deploy

```bash
./bootstrap.sh
```

The script deploys MySQL first, waits until the StatefulSet is ready and then deploys the app.

## 4. Validate MySQL

Pods are created one by one, in order:

```bash
kubectl get pods -n mysql
```

Expected: `mysql-0`, `mysql-1`, `mysql-2`, all `1/1 Running`.

Every pod has its own volume from `volumeClaimTemplates`:

```bash
kubectl get pvc -n mysql
```

Expected: `data-mysql-0`, `data-mysql-1`, `data-mysql-2`, all `Bound`.

The headless service has no cluster IP and lists all pods as endpoints:

```bash
kubectl get svc mysql -n mysql
kubectl get endpoints mysql -n mysql
```

`init.sql` was applied, `app_user` can see `app_db`:

```bash
kubectl exec -n mysql mysql-0 -- mysql -uapp_user -p1234 -e "SHOW DATABASES;"
```

## 5. Validate the app

```bash
kubectl get pods -n todoapp
```

All pods must be `1/1 Running`. The connection data comes from the Secret:

```bash
kubectl exec -n todoapp deploy/todoapp -- printenv NAME USER HOST
```

Expected: `app_db`, `app_user`, `mysql-0.mysql.mysql.svc.cluster.local`.

Django tables were created in MySQL on `mysql-0`:

```bash
kubectl exec -n mysql mysql-0 -- mysql -uapp_user -p1234 app_db -e "SHOW TABLES;"
```

Expected: Django tables, for example `auth_user`, `lists_todo`, `lists_todolist`.

Open the app:

```bash
kubectl port-forward service/todoapp-service 8080:80 -n todoapp
```

Open http://localhost:8080, create a to-do list, then check that the data is stored in MySQL:

```bash
kubectl exec -n mysql mysql-0 -- mysql -uapp_user -p1234 app_db -e "SELECT * FROM lists_todolist;"
```
