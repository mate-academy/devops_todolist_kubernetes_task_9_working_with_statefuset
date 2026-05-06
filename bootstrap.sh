#!/bin/bash
kubectl apply -f ./.infrastructure/namespace.yml
kubectl apply -f ./.infrastructure/mysql-config.yml
kubectl apply -f ./.infrastructure/mysql-secret.yml
kubectl apply -f ./.infrastructure/mysql-service.yml
kubectl apply -f ./.infrastructure/statefulSet.yml
kubectl apply -f ./.infrastructure/confgiMap.yml
kubectl apply -f ./.infrastructure/clusterIp.yml
kubectl apply -f ./.infrastructure/secret.yml
kubectl apply -f ./.infrastructure/deployment.yml