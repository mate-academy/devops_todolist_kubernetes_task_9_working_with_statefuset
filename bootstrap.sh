#!/bin/bash
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/namespace_sql.yml
kubectl apply -f .infrastructure/headless_sql.yml
kubectl apply -f .infrastructure/secret_sql.yml
kubectl apply -f .infrastructure/configMap_sql.yml
kubectl apply -f .infrastructure/statefulSet.yml
