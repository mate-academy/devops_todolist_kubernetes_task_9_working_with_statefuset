#!/bin/bash
set -e

# Cluster
kind create cluster --config cluster.yml

# MySQL
kubectl apply -f .infrastructure/mysqlNamespace.yml
kubectl apply -f .infrastructure/mysqlSecret.yml
kubectl apply -f .infrastructure/mysqlInitConfigMap.yml
kubectl apply -f .infrastructure/mysqlHeadlessService.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl rollout status statefulset/mysql -n mysql --timeout=600s

# ToDo app
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/dbSecret.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl rollout status deployment/todoapp -n todoapp --timeout=300s
