# ToDo App with MySQL StatefulSet Deployment

This guide describes how to deploy the Django ToDo application connected to a MySQL database managed by a Kubernetes StatefulSet.

## 1. Prerequisites

### Update & Push Docker Image
Since the application code has been updated to support MySQL (added `mysqlclient`), you must rebuild and push the image:

```
# Build the image with tag 4.0.0
docker build -t d4vp/todoapp:4.0.0 .

# Push the image to Docker Hub
docker push d4vp/todoapp:4.0.0
```
### Setup Kind Cluster
Use the provided configuration to spin up a Kind cluster (if not already running):

```
kind create cluster --config cluster.yml
```
# 2. Deployment
A bootstrap.sh script is provided to automate the deployment of all resources (Namespaces, Secrets, ConfigMaps, PV/PVC, MySQL StatefulSet, and App Deployment).

Run the following commands:

```
# Make the script executable
chmod +x bootstrap.sh

# Run the deployment script
./bootstrap.sh
```
# 3. Validation
### Validate MySQL StatefulSet
Ensure that the StatefulSet has successfully created 3 replicas.

```
kubectl get statefulset -n mysql
kubectl get pods -n mysql
```
Expected Output: You should see 3 pods: mysql-0, mysql-1, mysql-2 with status Running (1/1).

### Validate Application Connection
Check if the application pod is running and connected to the database.

```Bash
# Check app pods
kubectl get pods -n mateapp

# Check logs for connection errors
kubectl logs -l app=todolist -n mateapp
```
Expected Output: The logs should show the server starting without any "Can't connect to MySQL server" errors.

# 4. Persistence Test
To verify that the StatefulSet correctly retains data (VolumeClaimTemplates work):

### 1.Access the App: Forward the port to access the web interface:

```
kubectl port-forward svc/todo-service -n mateapp 8000:8000
```
Open http://localhost:8000 in your browser.

### 2.Create Data: Create a new ToDo task (e.g., "Test Persistence").

### 3.Simulate Failure: Delete the database pod (mysql-0) to simulate a crash/restart.

```
kubectl delete pod mysql-0 -n mysql
```
### 4.Verify Data:

Wait for mysql-0 to restart (kubectl get pods -n mysql -w).

Refresh the web page.

Result: The task "Test Persistence" should still be there.