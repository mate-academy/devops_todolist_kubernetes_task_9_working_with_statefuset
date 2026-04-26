# Django ToDo list

This is a to-do list web application with the basic features of most web apps, i.e., accounts/login, API, and interactive UI. To do this task, you will need:

- CSS | [Skeleton](http://getskeleton.com/)
- JS  | [jQuery](https://jquery.com/)

## Explore

Try it out by installing the requirements (the following commands work only with Python 3.8 and higher, due to Django 4):

```sh
pip install -r requirements.txt
```

Create a database schema:

```sh
python manage.py migrate
```

And then start the server (default is <http://localhost:8000>):

```sh
python manage.py runserver
```

You can now browse the [API](http://localhost:8000/api/) or start on the [landing page](http://localhost:8000/).

## Running app inside cluster

- Create cluster

    ```sh
    kind create cluster --config cluster.yml
    ```

- To run all required elements run script:

    ```sh
    ./bootstrap.sh
    ```

- Wait till all pods run

- Check if app pods are present

    ```sh
    kubectl get pods -n todoapp
    ```

- Check if all database pods are present

    ```sh
    kubectl get pods -n mysql
    ```

- Follow check if resource available <http://localhost:30007/>, if page loaded database initialized successfully
