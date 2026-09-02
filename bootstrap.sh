#!/bin/bash
set -e

# Create namespaces
kubectl apply -f .infrastructure/namespace.yml

# Create mysql namespace
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -

# Deploy MySQL secret for StatefulSet
kubectl apply -f .infrastructure/mysql-secret.yml

# Deploy app secret for Deployment (DB connection info)
kubectl apply -f .infrastructure/mysql-app-secret.yml

# Deploy MySQL StatefulSet (includes headless service + init configmap)
kubectl apply -f .infrastructure/statefulSet.yml

# Deploy app Deployment
kubectl apply -f .infrastructure/deployment.yml

# Wait for MySQL pods to be ready
echo "Waiting for MySQL pods to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=300s

# Wait for app Deployment to be ready
echo "Waiting for app Deployment to be ready..."
kubectl rollout status deployment/todoapp -n todoapp --timeout=300s

echo "Deployment complete!"
