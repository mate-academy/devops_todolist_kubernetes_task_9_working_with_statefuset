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

kubectl config current-context
In order to start the application you should execute in CLI the file bootstrap.sh
After start the application will be access by url
http://localhost:30007/
After start the mysql you can check the pods
kubectl get pods -n mysql
Then, you can see the logs of the pods. In order to check successful creating and starting
kubectl logs <pod`s_name> -n mysql

OR
You can start the application using the next commands
kind create cluster --config cluster.yml
kubectl apply -f namespace.yml
kubectl apply -f clusterIp.yml
kubectl apply -f nodeport.yml
kubectl apply -f configMap.yml
kubectl apply -f secret.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f deployment.yml
kubectl apply -f hpa.yml

Besides, in order to start mysql database with headless Service you should execute the next commands
kubectl apply -f st-namespace.yml
kubectl apply -f st-configMap.yml
kubectl apply -f st-secret.yml
kubectl apply -f st-service.yml
kubectl apply -f st-statefulSet.yml
After start the mysql you can check the pods
kubectl get pods -n mysql
Then, you can see the logs of the pods. In order to check successful creating and starting
kubectl logs <pod`s_name> -n mysql

