#!/bin/bash
#!/bin/bash

# Create kind cluster
kind create cluster --config cluster.yml

# Deploy MySQL
kubectl apply -f mysql-namespace.yml
kubectl apply -f mysql-secret.yml
kubectl apply -f mysql-configmap.yml
kubectl apply -f mysql-initdb.yml
kubectl apply -f mysql-service.yml
kubectl apply -f statefulSet.yml

# Deploy application
kubectl apply -f k8s/app-namespace.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/configMap.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
