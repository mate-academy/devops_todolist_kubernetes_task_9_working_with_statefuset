#!/bin/bash

# Зупинити виконання при будь-якій помилці
set -e


kubectl get namespace mysql >/dev/null 2>&1 || kubectl create namespace mysql

echo "📦 Застосування headless service..."
kubectl apply -f st-service.yaml

echo "🔐 Застосування Secret..."
kubectl apply -f st-secret.yaml

echo "⚙️ Застосування ConfigMap..."
kubectl apply -f st-configMap.yaml

echo "🧱 Застосування StatefulSet..."
kubectl apply -f statefulSet.yaml

echo "✅ Усі ресурси успішно застосовані."

