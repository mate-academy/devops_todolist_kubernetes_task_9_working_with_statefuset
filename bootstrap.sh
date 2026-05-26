#!/bin/bash

# Create namespaces
kubectl apply -f .infrastructure/namespace.yml
kubectl create namespace mysql

# Deploy MySQL secrets and configmap
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/configMapSQL.yml

# Deploy StatefulSet and headless Service
kubectl apply -f .infrastructure/statefulSet.yml

# Wait for MySQL to be ready
kubectl rollout status statefulset/mysql -n mysql

# Deploy app secrets and configmap
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/confgiMap.yml

# Deploy PVC and app
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
