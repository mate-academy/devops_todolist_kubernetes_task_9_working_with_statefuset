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


# MySQL StatefulSet Deployment

## How to Deploy

Run the `bootstrap.sh` script to deploy all resources

## Validation Steps

1. **Check if the StatefulSet is running:**

Check the status of the StatefulSet and its pods:

`kubectl get pods -n mysql`

2. **Verify that the ConfigMap data is mounted as files:**

`kubectl exec -it mysql-0 -n mysql -- ls /docker-entrypoint-initdb.d`

Verify that the `init.sql` file is present.

3. **Validate the Service is correctly set:**

Check that the MySQL service is correctly created and exposed:

`kubectl get svc -n mysql`

4. **Connect to the MySQL database and verify initialization:**

Exec into one of the MySQL pods and connect to the MySQL server:

`kubectl exec -it mysql-0 -n mysql -- mysql -umyuser -p`

Once connected, check if the `app_db` database exists:

`SHOW DATABASES;`


5. **Check if the APP is available:**
App should be available at address: `http://localhost:30007/`