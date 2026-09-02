#!/bin/bash
set -e

# Create kind cluster if not already created
if ! kind get clusters 2>/dev/null | grep -q "^kind$"; then
    echo "Creating kind cluster..."
    kind create cluster --config cluster.yml
fi

# Build application image
echo "Building todoapp image..."
docker build -t ikulyk404/todoapp:3.0.0 ./src

# Load image into kind cluster
echo "Loading image into kind cluster..."
kind load docker-image ikulyk404/todoapp:3.0.0

# Apply namespaces
echo "Applying namespaces..."
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-namespace.yml

# Apply MySQL infrastructure
echo "Applying MySQL infrastructure..."
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init-configmap.yml
kubectl apply -f .infrastructure/statefulSet.yml

# Apply App infrastructure
echo "Applying TodoApp infrastructure..."
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml

echo "Deployment complete."
