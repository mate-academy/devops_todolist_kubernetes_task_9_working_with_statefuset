# Django ToDo list

This is a to-do list web application with the basic features of most web apps, i.e., accounts/login, API, and interactive UI. To do this task, you will need:

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

You can now browse the [API](http://localhost:8000/api/) or start on the [landing page](http://localhost:8000/).

## Task

Create a Kubernetes manifest for a pod that will contain a ToDo app container:

1. Fork this repository.
1. Use `kind` to spin up a cluster from a `cluster.yml` configuration file.
1. Create a `statefulSet.yml` file for `StatefulSet` to manage MySQL.
1. `StatefulSet` requirement:
    1. `StatefulSet` should be deployed in a `mysql` namespace
    1. `StatefulSet` should have 3 replicas
    3. `StatefulSet` is reading sensitive data from a secret:
        1. `MYSQL_ROOT_PASSWORD`
        1. `MYSQL_USER`
        1. `MYSQL_PASSWORD`
    4. `StatefulSet` pods should have a `livenessProbe` and `readinessProbe`
    5. `StatefulSet` pods should have `requests` and `limits` for `CPU` and `Memory`
    6. MySQL db should be inited from an `init.sql` that should be propagated as a mounted volume in `/docker-entrypoint-initdb.d`
    7. `StatefulSet` should have `volumeClaimTemplates`
    8. `StatefulSet` should have a headless `Service` to expose db pods
1. `Deployment` requirements:
    1. Update your application so it can connect to a 0 indexed db pod (`mysql-0`)
    2. The application should read db connection information from a `Secret`:
        1. `NAME`
        2. `USER`
        3. `PASSWORD`
        4. `HOST`
1. `bootstrap.sh` should contain all the commands to deploy all the required resources in the cluster
1. `INSTRUCTION.md` should have instructions on how to validate the changes
1. Create PR with your changes and attach it for validation on a platform.

# Create the Kubernetes cluster
kind create cluster --config cluster.yml

# Create the MySQL namespace
kubectl create namespace mysql

# Apply the MySQL StatefulSet and headless service
kubectl apply -f statefulSet.yml

# Create the MySQL Secret
kubectl apply -f mysql-secret.yml

# Create the MySQL Init SQL ConfigMap
kubectl apply -f mysql-init-configmap.yml

# Create the application Secret
kubectl apply -f app-secret.yml

# Deploy the application
kubectl apply -f deployment.yml

# Check MySQL pods and logs
kubectl get pods -n mysql
kubectl logs <mysql-pod-name> -n mysql


# Verify database connection (optional)
kubectl exec -it <pod-name> -- sh
mysql -h mysql-0.mysql-headless.mysql.svc.cluster.local -u mysqluser -p
