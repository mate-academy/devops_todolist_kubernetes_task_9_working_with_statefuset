#!/bin/bash

# Створення namespace
kubectl create namespace mysql

# Застосування Secret
kubectl apply -f .infrastructure/mysql-secret.yml

# StatefulSet
kubectl apply -f .infrastructure/statefulSet.yml

# Service
kubectl apply -f .infrastructure/service.yml

# Secret for ToDo App
kubectl apply -f .infrastructure/secret.yml

# Deployment for ToDo App
kubectl apply -f .infrastructure/deployment.yml

