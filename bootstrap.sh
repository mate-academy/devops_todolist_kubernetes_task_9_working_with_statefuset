#!/bin/bash
set -e

echo "--- 1. Creating kind cluster ---"
kind create cluster --config cluster.yml

echo "--- 2. Applying Namespaces ---"
kubectl apply -f ./namespace.yml

echo "--- 3. Applying MySQL Infrastructure (StatefulSet) ---"
kubectl apply -f ./statefulSet-secret.yml
kubectl apply -f ./statefulSet-service.yml
kubectl apply -f ./statefulSet-configMap.yml
kubectl apply -f ./statefulSet.yml

echo "--- Waiting for mysql-0 pod to be ready (required for app migration) ---"
# Чекаємо на перший под, щоб забезпечити успішне підключення та міграцію застосунку
kubectl wait --for=condition=Ready pod/todoapp-mysql-0 -n mysql --timeout=300s

echo "--- 4. Applying Django App Infrastructure ---"
kubectl apply -f ./secret.yml 
kubectl apply -f ./configMap.yml
kubectl apply -f ./pv.yml
kubectl apply -f ./pvc.yml

echo "--- 5. Applying Deployment and NodePort Service ---"
kubectl apply -f ./deployment.yml
kubectl apply -f ./nodeport.yml

echo "--- Deployment complete! Check status with: kubectl get all -n todoapp ---"