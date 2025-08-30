#!/bin/bash
set -e

if ! kind get clusters | grep -q "^todoapp$"; then
  kind create cluster --name todoapp --config cluster.yml
else
  echo "Kind cluster 'todoapp' already exists."
fi

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/deployment.yml