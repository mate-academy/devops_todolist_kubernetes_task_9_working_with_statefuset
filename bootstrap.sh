#!/bin/bash

#Create namespaces
kubectl apply -f .infrastructure/namespace.yml
kubectl create ns mysql

#Create mysql db and additional resources
kubectl apply -f .infrastructure/mysql/st-service.yml
kubectl apply -f .infrastructure/mysql/st-secret.yml
kubectl apply -f .infrastructure/mysql/st-configMap.yml
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
