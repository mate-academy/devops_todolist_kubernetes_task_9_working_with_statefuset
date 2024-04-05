#!/bin/bash

kubectl apply -f .infrastructure/namespace.yml

kubectl apply -f .infrastructure/statefulSet.yml

echo "Checking the created todoapp resources..."
kubectl get all -n todoapp


kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodePort.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/deployment.yml

echo "Checking the created todoapp resources..."
kubectl get all -n todoapp
