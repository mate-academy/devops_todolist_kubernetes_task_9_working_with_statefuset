#!/usr/bin/env bash
set -euo pipefail

INFRA_DIR=".infrastructure"
NAMESPACE_APP="todoapp"
NAMESPACE_DB="mysql"

echo "Creating kind cluster..."
kind create cluster --config "${INFRA_DIR}/cluster.yml"

echo "Creating namespaces..."
kubectl create namespace "${NAMESPACE_APP}" || true
kubectl create namespace "${NAMESPACE_DB}" || true

echo "Applying MySQL resources..."
kubectl apply -f "${INFRA_DIR}/mysql-secret.yml" -n "${NAMESPACE_DB}"
kubectl apply -f "${INFRA_DIR}/mysql-configmap.yml" -n "${NAMESPACE_DB}"
kubectl apply -f "${INFRA_DIR}/mysql-statefulset.yml" -n "${NAMESPACE_DB}"

echo "Waiting for MySQL PVCs to be bound..."
kubectl wait --for=condition=Bound pvc --all -n "${NAMESPACE_DB}" --timeout=120s

echo "Applying application resources..."
kubectl apply -f "${INFRA_DIR}/secret.yml" -n "${NAMESPACE_APP}"
kubectl apply -f "${INFRA_DIR}/configmap.yml" -n "${NAMESPACE_APP}"
kubectl apply -f "${INFRA_DIR}/deployment.yml" -n "${NAMESPACE_APP}"

echo "Waiting for application rollout..."
kubectl rollout status deployment/todoapp -n "${NAMESPACE_APP}" --timeout=120s

echo "All resources applied successfully!"
