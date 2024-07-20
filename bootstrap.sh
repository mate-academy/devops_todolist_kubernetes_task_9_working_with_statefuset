#!/bin/bash
kubectl apply -f .infrastructure/statefulNamespace.yml
kubectl apply -f .infrastructure/statefulConfigMap.yml
kubectl apply -f .infrastructure/statefulSecret.yml
kubectl apply -f .infrastructure/statefulHeadlessService.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/deployment.yml