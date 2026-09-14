#!/bin/bash
set -e

echo "=== Creating Kind Cluster ==="
kind create cluster --config cluster.yml

echo "=== Creating Namespaces ==="
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

echo "=== Step 1: Applying all manifests in sequence ==="

# Deploy Service
kubectl apply -f .infrastructure/services.yml

# Deploy Secrets
kubectl apply -f .infrastructure/secret.yml

# Deploy ConfigMap
kubectl apply -f .infrastructure/configMap.yml

# Deploy ConfigMap for db
kubectl apply -f .infrastructure/configMap-db.yml

# Deploy Secrets for db
kubectl apply -f .infrastructure/secret-db.yml

# Deploy StatefulSet
kubectl apply -f .infrastructure/statefulSet.yml

# Deploy Persistent Volume
kubectl apply -f .infrastructure/pv.yml

# Deploy Persistent Volume Claim
kubectl apply -f .infrastructure/pvc.yml

# Deploy todoapp application
kubectl apply -f .infrastructure/deployment.yml

echo "=== Waiting for MySQL StatefulSet ==="
kubectl rollout status statefulset/mysql -n mysql --timeout=180s

echo "=== Waiting for TodoApp Deployment ==="
kubectl rollout status deployment/todoapp -n todoapp --timeout=120s

echo "=== All resources successfully deployed! ==="