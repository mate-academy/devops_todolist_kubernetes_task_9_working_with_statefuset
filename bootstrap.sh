#!/bin/bash
#!/bin/bash

# Create cluster
kind create cluster --config cluster.yml

# Apply everything
kubectl apply -f mysql-ns.yml
kubectl apply -f mysql-secret.yml
kubectl apply -f mysql-init-configmap.yml
kubectl apply -f mysql-headless-svc.yml
kubectl apply -f statefulSet.yml

# Wait for MySQL pods to be ready
kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=180s

# Deploy app
kubectl apply -f app-secret.yml
kubectl apply -f deployment.yml
