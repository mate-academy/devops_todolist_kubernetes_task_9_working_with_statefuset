#!/bin/bash

echo "Starting deployment..."

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-namespace.yml

kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-configmap.yml
kubectl apply -f .infrastructure/mysql-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl create secret generic mysql-pass \
  --from-literal=MYSQL_USER=mate_user \
  --from-literal=MYSQL_PASSWORD=mate_password_secret \
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