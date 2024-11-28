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


## Validate Deployment

### Validate MySQL StatefulSet

1. Check if the MySQL StatefulSet is running:

    ```bash
    kubectl get statefulset -n mysql
    ```

2. Verify that all replicas are up and running:

    ```bash
    kubectl get pods -n mysql
    ```

3. Check if the headless service for MySQL is created:

    ```bash
    kubectl get svc -n mysql
    ```

### Validate ToDo App Deployment

1. Check if the ToDo App Deployment is running:

    ```bash
    kubectl get deployment -n todoapp
    ```

2. Verify that the pods are up and running:

    ```bash
    kubectl get pods -n todoapp
    ```

3. Check if the services for ToDo App are created:

    ```bash
    kubectl get svc -n todoapp
    ```

### Connect to Database

To check if the application is correctly connected to the `mysql-0` database pod, you can perform the following:

1. Port-forward the ToDo App service to access it locally:

    ```bash
    kubectl port-forward svc/{ToDo-App-Service-Name} -n todoapp 8080:80
    ```

2. Access the application through a web browser or using curl:

    ```bash
    curl http://localhost:8080/
    ```

3. Check the application logs to confirm that it has successfully connected to the MySQL database:

    ```bash
    kubectl logs {todo-app-pod-name} -n todoapp
    ```

4. If the application has logic to validate the database connection on startup or through an API endpoint, you can invoke that to confirm connectivity.
PS: You may have to rebuild the Dockerfile image, since at the moment the application works with the sqllite database, in order for it to use mysql you need to change the settings DATABASE config and add mysql to the requirements.txt file.

## Troubleshooting

If any of the resources are not running or in an error state, you can check the logs or describe the resource for more information:

- Check logs:

    ```bash
    kubectl logs {pod-name} -n {namespace}
    ```

- Describe resource:

    ```bash
    kubectl describe {resource-type}/{resource-name} -n {namespace}
    ```