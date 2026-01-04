#!/bin/sh
set -e

echo "Creating namespaces"
kubectl create namespace todoapp || true
kubectl create namespace mateapp || true
kubectl create namespace mysql || true

echo "Applying ConfigMaps"
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/mysql-initdb.yml

echo "Applying Secrets"
kubectl apply -f .infrastructure/app-secret.yml
kubectl apply -f .infrastructure/mysql-secret.yml

echo "Applying Persistent Volumes"
kubectl apply -f .infrastructure/pv.yml

echo "Applying Persistent Volume Claims"
kubectl apply -f .infrastructure/pvc.yml

echo "Deploying MySQL StatefulSet"
kubectl apply -f .infrastructure/statefulSet.yml

echo "Deploying Application Deployment"
kubectl apply -f .infrastructure/deployment.yml

echo "Deploying DaemonSet"
kubectl apply -f .infrastructure/daemonset.yml

echo "Deploying CronJob"
kubectl apply -f .infrastructure/cronjob.yml

echo "All resources deployed"
echo "Checking resources"
kubectl get all -n todoapp
kubectl get all -n mateapp
kubectl get all -n mysql
kubectl get pv
kubectl get pvc -n todoapp
kubectl get pvc -n mysql

