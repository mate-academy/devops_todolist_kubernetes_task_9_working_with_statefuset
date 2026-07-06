#!/bin/bash

set -e

echo "Applying manifest files..."
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-configMap.yml
kubectl apply -f .infrastructure/service.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/pod.yml
kubectl apply -f .infrastructure/deployment.yml
echo "All manifest files have been applied successfully."
