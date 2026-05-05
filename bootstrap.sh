#!/bin/bash

# Create Kind cluster from cluster.yml
echo "Creating Kind cluster..."
kind create cluster --config cluster.yml

# Wait for cluster to be ready
echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Apply MySQL namespace
echo "Creating MySQL namespace..."
kubectl apply -f .infrastructure/mysql-namespace.yml

# Apply MySQL secret
echo "Creating MySQL secret..."
kubectl apply -f .infrastructure/mysql-secret.yml

# Apply MySQL ConfigMap for init.sql
echo "Creating MySQL ConfigMap..."
kubectl apply -f .infrastructure/mysql-configmap.yml

# Apply MySQL headless service
echo "Creating MySQL headless service..."
kubectl apply -f .infrastructure/mysql-service.yml

# Apply MySQL StatefulSet
echo "Creating MySQL StatefulSet..."
kubectl apply -f .infrastructure/statefulSet.yml

# Wait for MySQL pods to be ready
echo "Waiting for MySQL StatefulSet to be ready..."
kubectl wait --for=condition=Ready pod -l app=mysql -n mysql --timeout=300s

# Apply todoapp namespace
echo "Creating todoapp namespace..."
kubectl apply -f .infrastructure/namespace.yml

# Apply PersistentVolume
echo "Creating PersistentVolume..."
kubectl apply -f .infrastructure/pv.yml

# Apply PersistentVolumeClaim
echo "Creating PersistentVolumeClaim..."
kubectl apply -f .infrastructure/pvc.yml

# Apply ConfigMap
echo "Creating todoapp ConfigMap..."
kubectl apply -f .infrastructure/configMap.yml

# Apply Secret with DB connection info
echo "Creating todoapp Secret..."
kubectl apply -f .infrastructure/secret.yml

# Apply Deployment
echo "Creating todoapp Deployment..."
kubectl apply -f .infrastructure/deployment.yml

# Apply Services
echo "Creating todoapp Services..."
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml

# Apply HorizontalPodAutoscaler
echo "Creating HorizontalPodAutoscaler..."
kubectl apply -f .infrastructure/hpa.yml

echo ""
echo "========================================="
echo "All resources have been deployed successfully!"
echo "========================================="
echo ""
echo "MySQL StatefulSet pods:"
kubectl get pods -n mysql
echo ""
echo "Todoapp pods:"
kubectl get pods -n todoapp
