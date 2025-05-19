#!/bin/bash

kubectl create namespace mysql || true

kubectl apply -f .infrastructure/st-secret.yml

kubectl apply -f .infrastructure/st-configMap.yml

kubectl apply -f .infrastructure/st-service.yml

kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/app-secret.yml

kubectl apply -f .infrastructure/deployment.yml
