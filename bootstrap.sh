#!/bin/bash
echo "--creating namespaces--"
kubectl apply -f .infrastructure/namespace.yml

echo "--creating mysql db--"
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

echo "--creating app--"
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/hpa.yml
