#!/bin/bash
kubectl create ns mysql
kubectl apply -f st-service.yml
kubectl apply -f st-secret.yml
kubectl apply -f st-configMap.yml
kubectl apply -f StatefulSet.yml
kubectl apply -f deployment.yml