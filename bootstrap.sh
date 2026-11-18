#!/bin/bash

set -e
cd "$(dirname "$0")"

# Создаст кластер и переключится на него
kind create cluster --name statefusetcluster --config cluster.yml

# Создаст неймспейс для базы данных
kubectl apply -f .infrastructure/mysql/namespace.yml

# Создаст сервис для базы данных
kubectl apply -f .infrastructure/mysql/service.yml

# Создаст секрет для базы данных
kubectl apply -f .infrastructure/mysql/secret.yml

# Создаст ConfigMap для базы данных
kubectl apply -f .infrastructure/mysql/configMap.yml  

# Создаст сейфулсет для базы данных
kubectl apply -f .infrastructure/mysql/statefulSet.yml

# Дождется, пока все реплики MySQL будут готовы
kubectl rollout status statefulset/mysql -n mysql --timeout=600s

# Создаст неймспейс для приложения
kubectl apply -f .infrastructure/app/namespace.yml

# Создаст кластерIP для приложения
kubectl apply -f .infrastructure/app/clusterIP.yml

# Создаст нодпорт для приложения
kubectl apply -f .infrastructure/app/nodePort.yml

# Создаст секрет для приложения
kubectl apply -f .infrastructure/app/secret.yml

# Создаст конфигмап для приложения
kubectl apply -f .infrastructure/app/configMap.yml

# Создаст pv для приложения
kubectl apply -f .infrastructure/app/pv.yml

# Создаст pvc для приложения
kubectl apply -f .infrastructure/app/pvc.yml

# Создаст деплоймент для приложения
kubectl apply -f .infrastructure/app/deployment.yml 

# Создаст hpa для приложения   
kubectl apply -f .infrastructure/app/hpa.yml 

# Дождется, пока приложение будет готово
kubectl rollout status deployment/todoapp -n todoapp --timeout=300s