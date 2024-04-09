#!/bin/bash

# Change directory
cd .infrastructure/

# Create namespace mysql
kubectl create namespace mysql

# Create namespace todoapp
kubectl apply -f namespace.yml

# Run mysql resources
kubectl apply -f st-configMap.yml
kubectl apply -f st-secret.yml
kubectl apply -f st-service.yml
kubectl apply -f statefulSet.yml

# Run todoapp resources
kubectl apply -f configMap.yml
kubectl apply -f secret.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f clusterIp.yml
kubectl apply -f nodePort.yml
kubectl apply -f hpa.yml
kubectl apply -f deployment.yml
