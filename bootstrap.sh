#!/bin/bash
set -e

kind create cluster --config cluster.yml || true

kubectl apply -f .infrastructure/namespace.yml

kubectl apply -f .infrastructure/secretmysql.yml
kubectl apply -f .infrastructure/mysqlinit.yml
kubectl apply -f .infrastructure/service.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl rollout status statefulset/app-statefull -n mysql

kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml

kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml

kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml