# Django ToDo App Kubernetes Deployment

This guide covers the steps required to deploy and validate the Django ToDo App on a Kubernetes cluster.

## Prerequisites

Ensure you have the following installed and configured:
- Docker
- Kubernetes
- kubectl
- kind (if using locally)

## Steps to Deploy

1. Clone the repository to your local machine.
2. Navigate to the repository directory.
3. Run the `bootstrap.sh` script to deploy all the required resources to the cluster.

    ```bash
    ./bootstrap.sh
    ```

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

Replace `{ToDo-App-Service-Name}`, `{todo-app-pod-name}`, `{pod-name}`, `{namespace}`, and `{resource-type}/{resource-name}` with the actual names of your services, pods, and other resources.
