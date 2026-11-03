# Kubernetes ToDo Application

## Project Overview

This project deploys a Django ToDo application and a MySQL database in a local Kubernetes cluster created with Kind.

The infrastructure includes:
- Kind Kubernetes cluster with one control-plane node and two worker nodes.
- Django application deployed using a Kubernetes Deployment.
- MySQL database managed by a StatefulSet with three replicas.
- Persistent Volumes and Persistent Volume Claims for data storage.
- Kubernetes Secrets for sensitive configuration.
- ConfigMaps for application and database initialization configuration.
- ClusterIP and NodePort Services.
- Horizontal Pod Autoscaler (HPA).

## Prerequisites

Install the following tools:

- Docker Desktop
- kubectl
- Kind
- Git

Make sure Docker Desktop is running before deployment.

## Project Structure

```text
.
├── .infrastructure/
│   ├── clusterIp.yml
│   ├── confgiMap.yml
│   ├── db-secret.yml
│   ├── hpa.yml
│   ├── mysql-init.yml
│   ├── mysql-secret.yml
│   ├── mysql-service.yml
│   ├── namespace.yml
│   ├── nodeport.yml
│   ├── pv.yml
│   ├── pvc.yml
│   ├── secret.yml
│   ├── statefulSet.yml
│   └── deployment.yml
├── src/
│   ├── Dockerfile
│   └── todolist/
├── bootstrap.sh
├── cluster.yml
└── init.sql
```

## Deployment

Run the bootstrap script from the project root:

```bash
bash bootstrap.sh
```

The script performs the following operations:

1. Creates the Kind cluster if it does not already exist.
2. Creates Kubernetes namespaces.
3. Applies MySQL and Django configuration.
4. Creates persistent storage resources.
5. Deploys the MySQL StatefulSet.
6. Waits for MySQL to become ready.
7. Deploys the Django application.
8. Creates application Services and applies HPA configuration.
9. Displays the status of the deployed Pods.

## Verify Deployment

Check Kubernetes nodes:

```bash
kubectl get nodes
```

Check MySQL resources:

```bash
kubectl get pods -n mysql
kubectl get statefulsets -n mysql
```

Check Django resources:

```bash
kubectl get pods -n todoapp
kubectl get deployments -n todoapp
kubectl get services -n todoapp
```

Check persistent storage:

```bash
kubectl get pv
kubectl get pvc -n todoapp
kubectl get pvc -n mysql
```

Check autoscaling:

```bash
kubectl get hpa -n todoapp
```

HPA requires Metrics Server to provide CPU and memory metrics.

## Access the Application

To access the Django application locally, run:

```bash
kubectl port-forward --address 0.0.0.0 -n todoapp service/todoapp-service 8091:80
```

Open the following address in a browser on the host machine:

```text
http://localhost:8091
```

To access the application from another device on the same Wi-Fi network, use the host machine's local IPv4 address:

```text
http://<HOST-IP>:8091
```

Keep the port-forward process running while using the application.

## Cleanup

To delete the Kind cluster:

```bash
kind delete cluster
```

This removes the local Kubernetes cluster and its resources.
