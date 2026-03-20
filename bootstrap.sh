#!/bin/bash
set -e

kind create cluster --config cluster.yml

kubectl apply -f .infrastructure/namespace.yml
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -

kubectl create configmap mysql-config \
  --from-literal=init.sql="CREATE DATABASE IF NOT EXISTS tododb;" \
  -n mysql \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
