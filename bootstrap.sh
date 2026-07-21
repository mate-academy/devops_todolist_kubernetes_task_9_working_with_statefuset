#!/bin/bash
set -e

kind create cluster --name test1 --config cluster.yml

# Namespaces
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/st-ns.yml

# MySQL StatefulSet resources
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/statefulSet.yml

# Application resources
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/hpa.yml