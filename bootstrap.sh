#!/bin/bash
# Mysql boot part
kubectl apply -f ./.infrastructure/namespace.yml
kubectl apply -f ./.infrastructure/mysql-config.yml
kubectl apply -f ./.infrastructure/mysql-secret.yml
kubectl apply -f ./.infrastructure/mysql-service.yml
kubectl apply -f ./.infrastructure/statefulSet.yml
# Todoapp boot part
kubectl apply -f ./.infrastructure/configMap.yml
kubectl apply -f ./.infrastructure/clusterIp.yml
kubectl apply -f ./.infrastructure/secret.yml
kubectl apply -f ./.infrastructure/deployment.yml