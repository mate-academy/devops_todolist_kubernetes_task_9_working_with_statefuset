#!/bin/bash

# Create namespaces
kubectl apply -f .infrastructure/namespace.yml

# Deploy application secrets and configmap
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/configMap.yml

# Deploy MySQL StatefulSet and Headless Service
kubectl apply -f .infrastructure/statefulSet.yml

# Waiting for MySQL to be ready
kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=300s

# Deploy application
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
