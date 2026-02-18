#!/bin/bash
set -euo pipefail  # Зупинити скрипт при помилці, неіснуючій змінній або помилці в конвеєрі

# 1. Ініціалізація кластера
kind create cluster --config cluster.yml

# 2. Namespaces
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/namespace-mysql.yml

# 3. Сховище та конфігурації
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/configMap-mysql.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/db-conn-secret.yml

# 4. MySQL (Service МАЄ бути перед StatefulSet)
kubectl apply -f .infrastructure/mysql-headless.yml
kubectl apply -f .infrastructure/statefulSet.yml

echo "⏳ Waiting for MySQL replicas to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=120s

# 5. Додаток
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml

echo "✅ Deployment finished successfully!"