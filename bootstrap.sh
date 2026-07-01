#!/bin/bash
set -euo pipefail

echo "==> Starting cluster kind..."
kind create cluster --config cluster.yml

echo "==> Applying StatefulSet (namespace mysql, Secret, ConfigMap, Service)..."
kubectl apply -f statefulSet.yml

echo "==> Waiting for MySQL StatefulSet to be ready (may take up to 2 min)..."
kubectl rollout status statefulset/mysql -n mysql --timeout=120s

echo "==> Applying Secret to the application..."
kubectl apply -f app-db-secret.yml

echo "==> Applying Deployment to the application..."
kubectl apply -f .infrastructure/deployment.yml

echo "==> Waiting for Deployment to be ready..."
kubectl rollout status deployment/todoapp -n todoapp --timeout=60s

echo ""
echo "All resources successfully deployed!"
echo ""
echo "Useful commands:"
echo "kubectl get all -n mysql"
echo "kubectl get pods -n todoapp"
echo "kubectl logs statefulset/mysql -n mysql"