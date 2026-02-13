#!/bin/bash

set -euo pipefail
kind create cluster --config cluster.yml
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/headless-service.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl rollout status statefulset/mysql -n mysql --timeout=180s
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl rollout status deployment/todoapp -n todoapp --timeout=120s
kubectl apply -f .infrastructure/hpa.yml





