#!/bin/bash
set -e
kubectl apply -f .infrastructure/namespace-mysql.yml
kubectl apply -f .infrastructure/namespace-todoapp.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret-app.yml
kubectl apply -f .infrastructure/secret-db.yml
kubectl apply -f .infrastructure/StSet-headless-service.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/nodePort.yml
kubectl apply -f .infrastructure/clusterIP.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/deployment.yml
