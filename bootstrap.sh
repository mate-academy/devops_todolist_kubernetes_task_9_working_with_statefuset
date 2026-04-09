#!/bin/bash

set -e

echo "Creating namespaces..."
kubectl apply -f .infrastructure/ss-namespace.yml
kubectl apply -f .infrastructure/namespace.yml

echo "Creating MySQL resources..."
kubectl apply -f .infrastructure/ss-secret.yml
kubectl apply -f .infrastructure/ss-configMap.yml
kubectl apply -f .infrastructure/ss-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

echo "Creating todoapp resources..."
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/db-secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml

echo "Done!"