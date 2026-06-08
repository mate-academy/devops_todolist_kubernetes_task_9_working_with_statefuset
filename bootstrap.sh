#!/bin/bash
set -e

kind create cluster --config cluster.yml || true

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=300s

kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/db-secret.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml

kubectl wait --for=condition=ready pod -l app=todoapp -n todoapp --timeout=300s

echo "Deployment completed successfully"
