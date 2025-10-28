#!/bin/bash

echo "🚀 Starting full Kubernetes deployment..."

# 1️⃣ Создание Namespace'ов (для MySQL и todoapp, если оба в namespace.yml)
kubectl apply -f .infrastructure/namespace.yml

# 2️⃣ Создание секретов и конфигов
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/configMap.yml

# 3️⃣ Создание Persistent Volume и Claim
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml

# 4️⃣ Создание StatefulSet для MySQL
kubectl apply -f .infrastructure/statefulSet.yml

# 5️⃣ Создание Service для MySQL (headless / clusterIP)
#kubectl apply -f .infrastructure/clusterIp.yml

# 6️⃣ Деплой приложения todoapp
kubectl apply -f .infrastructure/deployment.yml

# 7️⃣ Сервис для приложения (NodePort)
kubectl apply -f .infrastructure/nodeport.yml

# 8️⃣ HorizontalPodAutoscaler (если требуется)
kubectl apply -f .infrastructure/hpa.yml

echo "✅ All resources deployed successfully!"
