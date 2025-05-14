#!/bin/bash

# Create kind cluster
kind create cluster --config cluster.yml

# Create namespace
kubectl apply -f .infrastructure/namespace.yml

# Create secrets
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/app-secret.yml

# Create ConfigMap
kubectl apply -f .infrastructure/mysql-config.yml

# Create headless service
kubectl apply -f .infrastructure/mysql-service.yml

# Create StatefulSet
kubectl apply -f .infrastructure/statefulSet.yml

# Wait for pods to be ready
echo "Waiting for MySQL pods to be ready..."
kubectl wait --namespace mysql \
  --for=condition=ready pod \
  --selector=app=mysql \
  --timeout=300s
