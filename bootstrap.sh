#!/bin/bash

kind create cluster --config cluster.yml

cd .infrastructure/

kubectl apply -f namespace.yml
kubectl apply -f secret.yml
kubectl apply -f configMap.yml
kubectl apply -f st-configMap.yml
kubectl apply -f st-secret.yml
kubectl apply -f st-service.yml
kubectl apply -f statefulSet.yml
kubectl apply -f deployment.yml