#!/bin/bash
set -euo pipefail

# kind create cluster --config cluster.yml

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml

kubectl apply -f .infrastructure/mysql-namespace.yml
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init-configmap.yml
kubectl apply -f .infrastructure/mysql-headless-svc.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/todoapp-db-secret.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
