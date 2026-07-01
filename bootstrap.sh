#!/bin/bash
set -e

kind create cluster --config cluster.yml

kubectl create namespace todoapp
kubectl create namespace mysql

# MySQL resources
kubectl apply -f .infrastructure/st-secrets.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

# Wait for MySQL to be ready
kubectl rollout status statefulset/mysql -n mysql --timeout=120s

# TodoApp resources
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml