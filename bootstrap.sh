#!/usr/bin/env bash
set -euo pipefail

INFRA_DIR=".infrastructure"
KIND_CLUSTER_NAME="todo-kind"

echo "1) Create kind cluster (if not exists)..."
if ! kind get clusters | grep -q "^${KIND_CLUSTER_NAME}$"; then
  kind create cluster --name "${KIND_CLUSTER_NAME}" --config cluster.yml
else
  echo "kind cluster ${KIND_CLUSTER_NAME} already exists"
fi

echo "2) Apply namespaces..."
kubectl apply -f "${INFRA_DIR}/namespace-mysql.yml"
kubectl apply -f "${INFRA_DIR}/app-namespace.yml"

echo "3) Apply MySQL ConfigMap and Secret (namespace: mysql)..."
kubectl apply -f "${INFRA_DIR}/mysql-configmap-init.yml" -n mysql
kubectl apply -f "${INFRA_DIR}/mysql-secret.yml" -n mysql

echo "4) Apply headless service..."
kubectl apply -f "${INFRA_DIR}/mysql-headless-svc.yml" -n mysql

echo "5) Apply Persistent StatefulSet (StatefulSet + PVCs)..."
kubectl apply -f "${INFRA_DIR}/mysql-statefulset.yml" -n mysql

echo "6) Wait for mysql pods (mysql-0) to be Ready..."
kubectl wait --for=condition=Ready pod -l app=mysql -n mysql --timeout=180s

echo "7) Apply app secret and app deployment..."
kubectl apply -f "${INFRA_DIR}/app-secret.yml" -n app
kubectl apply -f "${INFRA_DIR}/app-deployment.yml" -n app

echo "8) Wait for app rollout..."
kubectl rollout status deployment/todoapp -n app --timeout=120s

echo "Done. Check resources:"
echo "  kubectl get sts -n mysql"
echo "  kubectl get pods -n mysql"
echo "  kubectl get pods -n app"
