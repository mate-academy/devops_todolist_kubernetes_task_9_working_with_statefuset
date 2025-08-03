#!/bin/bash

# To stop the script, if the script goes wrong
set -e

# Creating namespaces first
kubectl apply -f .infrastructure/namespace.yml

# Waiting some times to create namespaces
sleep 3

# Creating PV & PVC for todoapp
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml

# Creating secret and configMap
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/configMap.yml

# Creating statefulSet for mysql
kubectl apply -f .infrastructure/statefulSet.yml

# Creating headless service for mysql
kubectl apply -f .infrastructure/st-service.yml

# Creating deployment
kubectl apply -f .infrastructure/deployment.yml
