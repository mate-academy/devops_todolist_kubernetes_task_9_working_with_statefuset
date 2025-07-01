# Instructions for deployment and validation

## Prerequisites

- Docker and [kind](https://kind.sigs.k8s.io/) installed
- kubectl installed and configured
- Python 3.8+ (for local testing)

## Step 1: Deploy the kubernetes cluster

1. Create the kind cluster using the provided configuration:
   ```bash
   kind create cluster --config cluster.yml
   ```

## Step 2: Run the bootstrap script

1. Run the provided script to deploy all resources:
   ```bash
   ./bootstrap.sh
   ```

## Step 3: Validate the deployment

### 1. Check pod status

- Ensure all pods are running:
  ```bash
  kubectl get pods -A
  ```

### 2. Verify MySQL StatefulSet

- Check that three MySQL pods are running in the `mysql` namespace:
  ```bash
  kubectl get pods -n mysql
  ```
- Check that the headless service is created:
  ```bash
  kubectl get svc -n mysql
  ```

### 3. Test MySQL Connection from application pod

- Exec into the Django application pod:
  ```bash
  kubectl get pods # Find the app pod name
  kubectl exec -it <app-pod-name> -- /bin/bash
  ```
- Test database connection:
  ```bash
  python manage.py dbshell
  ```
- Follow the [MySQLdb User’s Guide](https://mysqlclient.readthedocs.io/user_guide.html) to connect to the MySQL pod. If connected, run `SHOW TABLES;` to verify tables are created.

### 4. Test Application Functionality

- Port-forward the application service:
  ```bash
  kubectl port-forward svc/<app-service-name> 8000:8000
  ```
- Open [http://localhost:8000](http://localhost:8000) in your browser.
- Register a user, log in, and create a to-do item to confirm the app is working.
