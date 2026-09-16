#!/bin/bash
set -e

echo "1. Створюємо кластер Kind..."
kind create cluster --config cluster.yml

echo "2. Створюємо необхідні namespaces..."
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

echo "3. Застосовуємо конфіги та секрети..."
kubectl apply -f st-configMap.yml
kubectl apply -f st-secret.yml
kubectl apply -f secret.yml

echo "4. Застосовуємо сервіси..."
kubectl apply -f st-service.yml

echo "5. Застосовуємо базу даних (StatefulSet) та додаток (Deployment)..."
kubectl apply -f statefulSet.yml
kubectl apply -f deployment.yml

echo "Успішно! Усі ресурси розгорнуто."