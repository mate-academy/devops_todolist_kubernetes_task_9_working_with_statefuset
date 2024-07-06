# Django ToDo list

This is a todo list web application with basic features of most web apps, i.e., accounts/login, API, and interactive UI. To do this task, you will need:

- CSS | [Skeleton](http://getskeleton.com/)
- JS | [jQuery](https://jquery.com/)

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
   1. `StatefulSet` is reading sensetive data from a secret:
      1. `MYSQL_ROOT_PASSWORD`
      1. `MYSQL_USER`
      1. `MYSQL_PASSWORD`
   1. `StatefulSet` pods should have a `livenessProbe` and `readinessProbe`
   1. `StatefulSet` pods should have a `requests` and `limits` for `CPU` and `Memory`
   1. MySQL db should be inited from an `init.sql` that should be propagated as a mounted volume in `/docker-entrypoint-initdb.d`
   1. `StatefulSet` should have `volumeClaimTemplates`
   1. `StatefulSet` should have a headless `Service` to expose db pods
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

1. You could recreate cluster if you need it by running command below

```
kind delete cluster
kind create cluster --config cluster.yml
```

2. To deploying all the required resources in the cluster run command

```
sh bootstrap.sh
```

3. Now you can enjoy fantastic todo application on http://localhost:30007/ or http://127.0.0.1:30007

4. Connect to statefulSet with 0 index

```
kubectl exec -it mysql-0 -n mysql -- sh
```

5. Check for successfully created todoapp_db

```
mysql -h mysql-0.todoapp-mysql -u root --password=1234 -e "SHOW DATABASES;"
```

6. Get one pod name of deployment from pods list

```
kubectl get pods -o wide -n todoapp
```

7. Connect to shell of running pod

```
kubectl exec -it <one of running pod name> -n todoapp -- sh
```

8. Run 'printenv' command and check config env variable HOST with DB connection string and other connection information

```
printenv
```
