#!/bin/bash

kubectl apply -f .infrastructure/st-namespace.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/deployment.yml
