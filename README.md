# Django ToDo list

This is a todo list web application with basic features of most web apps, i.e., accounts/login, API, and interactive UI. To do this task, you will need:

- CSS | [Skeleton](http://getskeleton.com/)
- JS  | [jQuery](https://jquery.com/)

## Explore

Try it out by installing the requirements (the following commands work only with Python 3.8 and higher, due to Django 4):

```
pip install -r requirements.txt
```

Create a database schema:

```
python manage.py migrate
```

And then start the server (default is http://localhost:8000):

```
python manage.py runserver
```

Now you can browse the [API](http://localhost:8000/api/) or start on the [landing page](http://localhost:8000/).

## Task

Create a kubernetes manifest for a pod which will containa ToDo app container:

1. Fork this repository.
1. Use `kind` to spin up a cluster from a `cluster.yml` configuration file.
1. Create a `statefulSet.yml` file for `StatefulSet` to manage MySQL.
1. `StatefulSet` requirement:
    1. `StatefulSet` should be deployed in a `mysql` namespace
    1. `StatefulSet` should have 3 replicas
    3. `StatefulSet` is reading sensetive data from a secret:
        1. `MYSQL_ROOT_PASSWORD`
        1. `MYSQL_USER`
        1. `MYSQL_PASSWORD`
    4. `StatefulSet` pods should have a `livenessProbe` and `readinessProbe`
    5. `StatefulSet` pods should have a `requests` and `limits` for `CPU` and `Memory`
    6. MySQL db should be inited from an `init.sql` that should be propagated as a mounted volume in `/docker-entrypoint-initdb.d`
    7. `StatefulSet` should have `volumeClaimTemplates`
    8. `StatefulSet` should have a headless `Service` to expose db pods
1. `Deployment` requirments:
    1. Update your application so it could connect to a 0 indexed db pod (mysql-0)
    2. Application should read db connecion information from a `Secret`:
        1. `NAME`
        2. `USER`
        3. `PASSWORD`
        4. `HOST`
1. `bootstrap.sh` should containe all the commands to deploy all the required resources in the cluster
1. `README.md` should have instructuions on how to validate the changes
1. Create PR with your changes and attach it for validation on a platform.

---

### 1. Deploy
Use:
```bash
./bootstrap.sh
```
```yaml
--creating namespaces--
namespace/todoapp created
namespace/mysql created
--creating mysql db--
configmap/mysql-config created
secret/mysql-secrets created
service/mysql created
statefulset.apps/mysql created
--creating app--
configmap/app-config created
secret/app-secret created
service/todoapp-service created
service/todoapp-nodeport created
persistentvolume/pv-data created
persistentvolumeclaim/pvc-data created
deployment.apps/todoapp created
horizontalpodautoscaler.autoscaling/todoapp created
```
### 2. Validation

1. Check the StatefulSet and its pods:
```bash
kubectl get statefulset -n mysql -o wide
```
```yaml
NAME    READY   AGE     CONTAINERS   IMAGES
mysql   3/3     2m52s   mysql        mysql:8.0
```
```bash
kubectl get pods -n mysql
```
```yaml
NAME      READY   STATUS    RESTARTS   AGE
mysql-0   1/1     Running   0          3m43s
mysql-1   1/1     Running   0          3m27s
mysql-2   1/1     Running   0          3m8s
```

2. Verify that the ConfigMap data is mounted as files:

```bash
kubectl exec -it mysql-0 -n mysql -- cat ./docker-entrypoint-initdb.d/init.sql
```
```yaml
GRANT ALL PRIVILEGES ON mysql_db.* TO 'mysqluser'@'%';
```

3. Verify initialization:

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -umysqluser -p
```
```yaml
Enter password: 
```
```bash
userpw
```
```yaml
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 1292
Server version: 8.0.38 MySQL Community Server - GPL

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```
```bash
SHOW DATABASES;
```
```yaml
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql_db           |
| performance_schema |
+--------------------+
3 rows in set (0.04 sec)
```
