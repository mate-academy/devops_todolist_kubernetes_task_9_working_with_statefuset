#!/bin/bash
set -euo pipefail

echo "==> Creating namespaces"
kubectl apply -f namespace.yml
kubectl apply -f mysql-namespace.yml

echo "==> Deploying MySQL (mysql namespace)"
kubectl apply -f mysql-secret.yml
kubectl apply -f mysql-init-configmap.yml
kubectl apply -f mysql-headless-service.yml
kubectl apply -f mysql-statefulset.yml

echo "==> Waiting for MySQL StatefulSet pods to become ready"
kubectl rollout status statefulset/mysql -n mysql --timeout=300s

echo "==> Deploying application configuration (todoapp namespace)"
kubectl apply -f confgiMap.yml
kubectl apply -f secret.yml
kubectl apply -f db-secret.yml

echo "==> Deploying application storage"
kubectl apply -f pv.yml
kubectl apply -f pvc.yml

echo "==> Deploying application workload"
kubectl apply -f deployment.yml
kubectl apply -f hpa.yml

echo "==> Waiting for todoapp Deployment to become ready"
kubectl rollout status deployment/todoapp -n todoapp --timeout=300s

echo "==> Deploying application services"
kubectl apply -f clusterIp.yml
kubectl apply -f nodeport.yml

echo "==> Done. Current state:"
kubectl get all -n mysql
kubectl get all -n todoapp
