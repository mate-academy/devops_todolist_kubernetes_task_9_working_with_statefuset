#!/bin/bash

# Namespace
kubectl apply -f .infrastructure/namespace.yml

# Secrets & ConfigMaps
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init-configmap.yml

# PVC (якщо ви використовуєте окремий PVC)
kubectl apply -f .infrastructure/pvc.yml

# Services
kubectl apply -f .infrastructure/mysql-service.yml
kubectl apply -f .infrastructure/nodeport.yml

# StatefulSet & Application Deployment
kubectl apply -f .infrastructure/mysql-statefulset.yml
kubectl apply -f .infrastructure/deployment.yml
