#!/bin/bash

# Create namespace for mysql
kubectl apply -f .infrastructure/namespace.yml

# Create Secret for DB credentials
kubectl apply -f .infrastructure/secret.yml

# Apply the ConfigMap
kubectl apply -f .infrastructure/confgiMap.yml

# Deploy StatefulSet for MySQL
kubectl apply -f .infrastructure/statefulSet.yml

# Deploy the application (ToDo app)
kubectl apply -f .infrastructure/deployment.yml

# Apply the HorizontalPodAutoscaler
kubectl apply -f .infrastructure/hpa.yml

# Expose MySQL via ClusterIP
kubectl apply -f .infrastructure/clusterIp.yml

# Expose app via NodePort
kubectl apply -f .infrastructure/nodeport.yml
