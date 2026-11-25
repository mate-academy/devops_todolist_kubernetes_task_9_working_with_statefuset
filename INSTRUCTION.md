# Task 9: StatefulSet

## 1. Create the cluster

```
kind create cluster --config cluster.yml
```

## 2. Build and push the application image

The application now uses MySQL (`mysqlclient`), so a new image is needed. Replace `<dockerhub-user>` with your Docker Hub name and set the same image in `.infrastructure/deployment.yml`:

```
docker build -t <dockerhub-user>/todoapp:4.0.0 -f src/Dockerfile src
docker push <dockerhub-user>/todoapp:4.0.0
```

Migrations are no longer run at build time: the container runs `python manage.py migrate` on start, when MySQL is available.

## 3. Deploy everything

```
bash bootstrap.sh
```

It creates the `mysql` namespace, Secret, ConfigMap with `init.sql`, the headless Service and StatefulSet (3 replicas), and then the `todoapp` namespace, ConfigMap, Secret, Deployment, Services and HPA.

## 4. Validate

### MySQL pods (StatefulSet)

```
kubectl get pods -n mysql
```

Expected: `mysql-0`, `mysql-1`, `mysql-2` are `1/1 Running` (started one by one).

### Each pod has its own volume

```
kubectl get pvc -n mysql
```

Expected: `data-mysql-0`, `data-mysql-1`, `data-mysql-2` are `Bound`.

### Database was created from init.sql

```
kubectl exec -n mysql mysql-0 -- sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"'
```

Expected: the database `tododb` is in the list.

### Application is running and connected to mysql-0

```
kubectl get pods -n todoapp
kubectl logs -n todoapp deployment/todoapp
```

Expected: pods are `1/1 Running`, the logs show all migrations as `OK`.

```
kubectl exec -n mysql mysql-0 -- sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE tododb; SHOW TABLES;"'
```

Expected: tables of the application (`lists_todo`, `lists_todolist`, `auth_user`, ...).

## Notes

- The app connects to `mysql-0.mysql.mysql.svc.cluster.local` (pod.service.namespace). The three replicas are independent databases, there is no data replication between them.
- Passwords in the Secrets are demo values. Never commit real secrets.
- On Windows (Git Bash) put `MSYS_NO_PATHCONV=1` before `kubectl exec` commands that contain paths.