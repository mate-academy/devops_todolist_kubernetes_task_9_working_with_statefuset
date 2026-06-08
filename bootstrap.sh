#!/bin/bash
set -e

kind create cluster --config cluster.yml || true

kubectl apply -f .infrastructure/statefulSet.yml

kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=300s

kubectl apply -f .infrastructure/db-secret.yml
kubectl apply -f .infrastructure/deployment.yml

kubectl wait --for=condition=ready pod -l app=todoapp -n todoapp --timeout=300s

echo "Deployment completed successfully"
