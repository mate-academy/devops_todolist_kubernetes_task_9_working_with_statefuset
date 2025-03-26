#!/bin/bash

# Створення Namespaces
kubectl create namespace mysql || true

# Створення Secret для MySQL
kubectl apply -f mysql-secret.yml

# Створення ConfigMap для init.sql
kubectl apply -f mysql-init-config.yml

# Створення Headless Service для MySQL
kubectl apply -f headless-service.yml

# Створення StatefulSet для MySQL
kubectl apply -f statefulSet.yml

# Створення Secret для App
kubectl apply -f app-secret.yml

# Розгортання додатку (Deployment)
kubectl apply -f deployment.yml
