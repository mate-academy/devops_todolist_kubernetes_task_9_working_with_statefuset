## Prerequisites

Ensure the following prerequisites are met before proceeding:

1. Kubernetes Cluster (either local or cloud-based, e.g., Minikube, AWS EKS, GKE, etc.)
2. kubectl installed and configured to interact with your Kubernetes cluster.
3. Docker image for the TodoApp application available.
4. Configuration and secrets files (`app-config.yml`, `app-secret.yml`, etc.) are available and applied.

## Deploying the Application

To deploy the application:

1. **Create Namespaces**: The namespaces `mysql` and `todoapp` should be created. If not already created, they can be done manually or automatically by the `bootstrap.sh` script.
   - The `mysql` namespace is for MySQL.
   - The `todoapp` namespace is for the TodoApp application.

2. **Deploy MySQL StatefulSet**: The MySQL StatefulSet ensures persistence for the MySQL database across pod restarts.
   - The stateful set YAML file (`statefulset.yml`) will define the number of replicas (3) and associated secrets for MySQL.
   
3. **Deploy TodoApp Deployment**: The TodoApp application is deployed via the `deployment.yml` file, which configures the required environment variables (such as database connection details from `app-secret.yml`).

4. **Apply PVC (Persistent Volume Claim)**: Persistent storage is necessary for both the MySQL data and TodoApp application data. This can be applied with `pvc.yml`.

5. **Apply Secrets**: The `app-secret.yml` contains the sensitive data required for connecting to the MySQL database (e.g., `DB_USER`, `DB_PASSWORD`).

6. **Apply ConfigMaps**: The `app-config.yml` contains the configurations for the TodoApp that are needed to initialize the app.

7. **Check Deployment Status**: Once deployed, check the pod and service status:
   - Run `kubectl get pods -n mysql` to ensure MySQL pods are running.
   - Run `kubectl get pods -n todoapp` to ensure the TodoApp pods are running.
   
8. **Expose Services**: Expose the MySQL and TodoApp services to allow external access:
   - MySQL is exposed using a headless service to allow the TodoApp to connect to it directly.
   - The TodoApp service is exposed for HTTP traffic.

9. **Validate the Application**: Ensure the TodoApp is accessible by browsing the exposed service and checking if the app can connect to MySQL successfully.

## Additional Notes

- The `bootstrap.sh` script will automate the deployment process by applying the necessary Kubernetes resources.
- The TodoApp connects to the MySQL instance by using environment variables set in the `app-secret.yml` file.
