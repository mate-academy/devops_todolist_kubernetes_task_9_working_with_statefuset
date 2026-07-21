# Instructions

## Deployment

All resources are deployed by the bootstrap script. Make it executable and run it from the repository root:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The script creates both namespaces, deploys the MySQL StatefulSet with its Secret, ConfigMap and headless Service, and then deploys the application with its ConfigMap, Secret, PV and PVC.

> Note: MySQL takes a couple of minutes to initialize on the first run. The application pod may restart a few times during this period — it cannot apply migrations until the database is ready. This is expected and resolves itself once MySQL becomes ready.

## Validation

### 1. MySQL StatefulSet is running

```bash
kubectl get pods -n mysql
```

Expected output — three pods, created sequentially (note the decreasing AGE, which confirms StatefulSet's ordered startup):

NAME READY STATUS RESTARTS AGE
mysql-0 1/1 Running 0 4m46s
mysql-1 1/1 Running 0 4m01s
mysql-2 1/1 Running 0 2m27s


Each pod has its own PersistentVolumeClaim:

```bash
kubectl get pvc -n mysql
```

Expected: `data-mysql-0`, `data-mysql-1`, `data-mysql-2`, all in `Bound` status.

### 2. The application is running and connected to MySQL

```bash
kubectl get pods -n todoapp
```

Expected: the pod is `Running` with `1/1` ready.

Check the logs — copy the pod name from the output above:

```bash
kubectl logs <pod-name> -n todoapp
```

Expected output — migrations applied against MySQL, followed by the server starting:

Applying contenttypes.0001_initial... OK
Applying auth.0001_initial... OK
...
Starting development server at http://0.0.0.0:8080/


This confirms the application connected to `mysql-0` using the credentials from the Secret.

### 3. The database actually contains the application tables

Connect to the first MySQL pod and list the tables:

```bash
kubectl exec -it mysql-0 -n mysql -- sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "USE app_db; SHOW TABLES;"'
```

Expected: a list of Django tables (`auth_user`, `django_migrations`, `lists_todo`, etc.), which proves the migrations were applied to MySQL rather than a local SQLite file.