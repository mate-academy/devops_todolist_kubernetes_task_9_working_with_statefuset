#!/bin/bash

echo "Starting deployment..."

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-namespace.yml

kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-configmap.yml
kubectl apply -f .infrastructure/mysql-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

echo "Creating application secret..."
kubectl create secret generic mysql-app-credentials \
  --from-literal=NAME=tododb \
  --from-literal=USER=mate_user \
  --from-literal=PASSWORD=mate_password_secret \
  --from-literal=HOST=mysql-0.mysql-service.mysql.svc.cluster.local \
  -n mateapp --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml

echo "Waiting for MySQL to start..."
sleep 15
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/service.yml

kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/daemonset.yml
kubectl apply -f .infrastructure/cronjob.yml

echo "Deployment finished!"