#!/usr/bin/env bash
set -euo pipefail

# === Config (можеш змінити під себе через змінні оточення) ===
: "${MYSQL_ROOT_PASSWORD:=root_pass_123}"
: "${MYSQL_USER:=todo_user}"
: "${MYSQL_PASSWORD:=todo_pass_123}"
: "${DB_NAME:=todoapp}"

# 1) kind cluster
if ! kind get clusters | grep -q "todo-cluster"; then
  kind create cluster --config cluster.yml
fi

# 2) Namespace mysql
kubectl get ns mysql >/dev/null 2>&1 || kubectl create ns mysql

# 3) Secrets (імперативно, без коміту паролів у Git)
if ! kubectl -n mysql get secret mysql-secret >/dev/null 2>&1; then
  kubectl -n mysql create secret generic mysql-secret \
    --from-literal=MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
    --from-literal=MYSQL_USER="${MYSQL_USER}" \
    --from-literal=MYSQL_PASSWORD="${MYSQL_PASSWORD}"
fi

if ! kubectl get secret todo-db-credentials >/dev/null 2>&1; then
  kubectl create secret generic todo-db-credentials \
    --from-literal=NAME="${DB_NAME}" \
    --from-literal=USER="${MYSQL_USER}" \
    --from-literal=PASSWORD="${MYSQL_PASSWORD}" \
    --from-literal=HOST="mysql-0.mysql.mysql.svc.cluster.local"
fi

# 4) ConfigMap + Headless Service + StatefulSet
kubectl apply -f mysql-configmap-init.yml
kubectl apply -f statefulSet.yml

# 5) App Deployment
kubectl apply -f app-deployment.yml

# 6) Очікування готовності
kubectl -n mysql rollout status statefulset/mysql --timeout=5m
kubectl rollout status deployment/todo-app --timeout=3m

echo "All resources applied successfully."