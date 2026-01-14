#!/bin/bash
set -e # Зупинити скрипт при помилці

echo "--- Step 1: Namespaces ---"
kubectl apply -f namespace.yml

echo "--- Step 2: Storage ---"
kubectl apply -f pv.yml
kubectl apply -f pvc.yml

echo "--- Step 3: Configs and Secrets ---"
kubectl apply -f configMap.yml
kubectl apply -f secret.yml

echo "--- Step 4: Database (MySQL) ---"
kubectl apply -f st-service.yml
kubectl apply -f statefulSet.yml

echo "Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod/mysql-0 -n mysql --timeout=60s

echo "--- Step 5: Application (TodoApp) ---"
kubectl apply -f deployment.yml
kubectl apply -f clusterIp.yml
kubectl apply -f nodeport.yml

echo "--- Step 6: Scaling ---"
kubectl apply -f hpa.yml

echo "SUCCESS: Infrastructure deployed!"