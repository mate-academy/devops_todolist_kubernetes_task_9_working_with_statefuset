#!/bin/bash

# creating cluster
kind delete cluster
kind create cluster --config ./cluster.yml

# crating database
kubectl apply -f .infrastructure/mysql/namespace.yml
kubectl apply -f .infrastructure/mysql/configMap.yml
kubectl apply -f .infrastructure/mysql/secret.yml
kubectl apply -f .infrastructure/mysql/service.yml
kubectl apply -f .infrastructure/mysql/statefulSet.yml

#creating app
kubectl apply -f .\.infrastructure\namespace.yml
kubectl apply -f .\.infrastructure\confgiMap.yml
kubectl apply -f .\.infrastructure\secret.yml
kubectl apply -f .\.infrastructure\clusterIp.yml
kubectl apply -f .\.infrastructure\nodeport.yml
kubectl apply -f .\.infrastructure\pv.yml
kubectl apply -f .\.infrastructure\pvc.yml
kubectl apply -f .\.infrastructure\deployment.yml
kubectl apply -f .\.infrastructure\hpa.yml
