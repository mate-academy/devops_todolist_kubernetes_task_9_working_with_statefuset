#!/bin/bash

# Create namespaces
echo "Creating namespaces..."
kubectl create namespace mysql || echo "Namespace 'mysql' already exists."
kubectl create namespace todoapp || echo "Namespace 'todoapp' already exists."

# Deploy MySQL resources
echo "Deploying MySQL resources..."
kubectl apply -f ./.infrastructure/namespace.yml
kubectl apply -f ./.infrastructure/st-configMap.yml
kubectl apply -f ./.infrastructure/st-secret.yml
kubectl apply -f ./.infrastructure/st-service.yml
kubectl apply -f ./.infrastructure/statefulSet.yml

# Verify MySQL resources
echo "Checking the created MySQL resources..."
kubectl get all -n mysql

# Deploy todoapp resources
echo "Deploying todoapp resources..."
kubectl apply -f ./.infrastructure/configMap.yml
kubectl apply -f ./.infrastructure/secret.yml
kubectl apply -f ./.infrastructure/pv.yml
kubectl apply -f ./.infrastructure/pvc.yml
kubectl apply -f ./.infrastructure/clusterIp.yml
kubectl apply -f ./.infrastructure/nodePort.yml
kubectl apply -f ./.infrastructure/hpa.yml
kubectl apply -f ./.infrastructure/deployment.yml

# Verify todoapp resources
echo "Checking the created todoapp resources..."
kubectl get all -n todoapp

# Final message
echo "Bootstrap process completed successfully!"
