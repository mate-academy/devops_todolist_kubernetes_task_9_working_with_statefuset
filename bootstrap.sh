#!/bin/bash
# Create necessary namespaces
kubectl create namespace mysql || echo "Namespace mysql already exists"
kubectl create namespace todoapp || echo "Namespace todoapp already exists"

# Deploy StatefulSet for MySQL
kubectl apply -f statefulset.yml

# Deploy the TodoApp Deployment
kubectl apply -f deployment.yml

# Apply the PersistentVolumeClaim (PVC)
kubectl apply -f pvc.yml

# Apply secrets
kubectl apply -f app-secret.yml

# Apply configMaps
kubectl apply -f app-config.yml

# Check if the pods are running
kubectl get pods -n mysql
kubectl get pods -n todoapp

# Expose the MySQL service
kubectl expose statefulset/mysql --name=mysql-service --port=3306 --target-port=3306 --namespace=mysql --cluster-ip=None

# Expose the TodoApp service
kubectl expose deployment todoapp --name=todoapp-service --port=8080 --target-port=8080 --namespace=todoapp

# Check if services are running
kubectl get svc -n mysql
kubectl get svc -n todoapp
