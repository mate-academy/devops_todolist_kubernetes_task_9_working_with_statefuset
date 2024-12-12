#!/bin/bash

kubectl apply -f .infrastructure/namespace.yml
kubectl create namespace mysql

# Apply MySQL StatefulSet and ConfigMap
kubectl apply -f .infrastructure/mysql/mysql-secret.yml
kubectl apply -f .infrastructure/mysql/init-configMap.yml
kubectl apply -f .infrastructure/mysql/mysql-headless-service.yml
kubectl apply -f .infrastructure/mysql/statefulSet.yml

#Create todoaapp and services
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/deployment.yml

