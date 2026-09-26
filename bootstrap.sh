#!/bin/bash

kubectl apply -f .infrastructure/st-cluster.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/st-namespace.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml