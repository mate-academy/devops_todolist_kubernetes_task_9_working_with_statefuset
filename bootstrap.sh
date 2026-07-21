#!/bin/bash

#Поднятие mysql кластера
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/sfs-secret.yml
kubectl apply -f .infrastructure/sfs-configMap.yml
kubectl apply -f .infrastructure/services.yml
kubectl apply -f .infrastructure/statefulSet.yml

#Поднятие todoapp-приложения кластера
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml