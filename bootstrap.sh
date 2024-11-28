#!/bin/bash
kubectl.exe apply -f .infrastructure/st-service.yml
kubectl.exe apply -f .infrastructure/st-configMap.yml
kubectl.exe apply -f .infrastructure/st-secret.yml
kubectl.exe apply -f .infrastructure/statefulSet.yml
kubectl.exe apply -f .infrastructure/secret.yml
kubectl.exe apply -f .infrastructure/deployment.yml
