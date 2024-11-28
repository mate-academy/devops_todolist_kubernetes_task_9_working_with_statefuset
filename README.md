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

# -----------------------------------

# Run the bootstrap script:

./bootstrap.sh

# This script will:

#   Create the mysql namespace.
#   Deploy all MySQL-related resources:
#          ConfigMap
#          Secrets
#          Service
#          StatefulSet
#   Check the status of MySQL resources.
#   Deploy all todoapp resources:
#          ConfigMap
#          Secrets
#          PersistentVolume and PersistentVolumeClaim
#          Services (ClusterIP and NodePort)
#          Horizontal Pod Autoscaler (HPA)
#          Deployment
#   Check the status of todoapp resources.

# 1. Check the created resources for MySQL:

kubectl get all -n mysql

# 2. Verify MySQL pods are running:

kubectl get pods -n mysql

# 3. Confirm the StatefulSet is configured properly:

kubectl describe statefulset mysql -n mysql

# 1.1 Check the created resources for todoapp:

kubectl get all -n todoapp

# 2.2 Verify the todoapp pods are running:

kubectl get pods -n todoapp

# 3.3 Find the NodePort or ClusterIP for the application:

kubectl get svc -n todoapp

# 3.4 Access the application using the NodePort service in a browser or API testing tool:

http://<node-ip>:<nodeport>

