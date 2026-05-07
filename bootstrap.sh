#!/bin/

# Exit on any error
set -e

echo "Deployment..."

# Step 1: Create kind cluster
echo "Creating kind cluster..."
kind create cluster --config cluster.yml

# Step 2: Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# Step 3: Deploy MySQL namespace and resources
echo "Deploying MySQL namespace..."
kubectl apply -f .infrastructure/namespace.yml

# Apply PersistentVolume
echo "Creating PersistentVolume..."
kubectl apply -f .infrastructure/pv.yml

# Apply PersistentVolumeClaim
echo "Creating PersistentVolumeClaim..."
kubectl apply -f .infrastructure/pvc.yml

echo "Deploying MySQL secrets..."
kubectl apply -f .infrastructure/secret.yml

echo "Deploying MySQL ConfigMap..."
kubectl apply -f .infrastructure/confgimap.yml

echo "Deploying MySQL StatefulSet and Service..."
kubectl apply -f .infrastructure/statefulSet.yml

# Step 4: Wait for MySQL pods to be ready
echo "Waiting for MySQL pods to be ready..."
kubectl wait --for=condition=Ready pod -l app=mysql -n mysql --timeout=300s

# Step 5: Deploy TodoApp
echo "Deploying TodoApp..."
kubectl apply -f deployment.yml

# Step 6: Wait for TodoApp to be ready
echo "Waiting for TodoApp to be ready..."
kubectl wait --for=condition=Ready pod -l app=todoapp -n todoapp --timeout=120s

echo "Deployment complete!"
echo ""
echo "To access the application, run:"
echo "  kubectl port-forward -n todoapp <pod-name> 8080:8080"
