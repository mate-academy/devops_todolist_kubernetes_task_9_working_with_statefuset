#!/bin/bash
cd .infrastructure
kubectl create ns mysql
kubectl apply -f st-service.yml
kubectl apply -f st-secret.yml
kubectl apply -f st-configMap.yml
kubectl apply -f statefullSet.yml