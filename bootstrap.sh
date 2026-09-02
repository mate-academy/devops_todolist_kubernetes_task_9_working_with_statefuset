#!/bin/bash

set -e


kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-namespace.yml


kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init-configmap.yml
kubectl apply -f .infrastructure/mysql-service.yml
kubectl apply -f .infrastructure/statefulSet.yml


kubectl rollout status statefulset/mysql -n mysql --timeout=300s


kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/db-secret.yml


kubectl apply -f .infrastructure/deployment.yml


kubectl rollout status deployment/todoapp -n todoapp --timeout=300s

POD=$(kubectl get pods \
  -n todoapp \
  -l app=todoapp \
  -o jsonpath='{.items[0].metadata.name}')


kubectl exec -n todoapp "$POD" -- python manage.py migrate
