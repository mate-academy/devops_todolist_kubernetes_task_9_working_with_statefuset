#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_DIR="${SCRIPT_DIR}/manifests"
CLUSTER_NAME="mysql-cluster"

echo "==> Checking prerequisites (kind, kubectl)..."
command -v kind >/dev/null 2>&1 || { echo "kind is required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "kubectl is required but not installed. Aborting."; exit 1; }

echo "==> Creating kind cluster '${CLUSTER_NAME}' (skipping if it already exists)..."
if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  kind create cluster --config "${SCRIPT_DIR}/cluster.yml"
else
  echo "Cluster '${CLUSTER_NAME}' already exists, reusing it."
fi

kubectl cluster-info --context "kind-${CLUSTER_NAME}"

echo "==> Creating namespaces..."
kubectl apply -f "${MANIFEST_DIR}/00-namespaces.yml"

echo "==> Creating MySQL credentials Secret..."
kubectl apply -f "${MANIFEST_DIR}/01-mysql-secret.yml"

echo "==> Creating ConfigMap from init.sql (mounted into /docker-entrypoint-initdb.d)..."
kubectl create configmap mysql-init-sql \
  --namespace mysql \
  --from-file=init.sql="${MANIFEST_DIR}/init.sql" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "==> Creating headless Service for MySQL..."
kubectl apply -f "${MANIFEST_DIR}/02-mysql-headless-service.yml"

echo "==> Creating MySQL StatefulSet..."
kubectl apply -f "${MANIFEST_DIR}/statefulSet.yml"

echo "==> Waiting for StatefulSet pods to become Ready (this can take a couple of minutes)..."
kubectl rollout status statefulset/mysql -n mysql --timeout=300s

echo "==> Creating application DB connection Secret..."
kubectl apply -f "${MANIFEST_DIR}/03-app-db-secret.yml"

echo "==> Creating application Deployment..."
kubectl apply -f "${MANIFEST_DIR}/04-app-deployment.yml"

echo "==> Waiting for application Deployment to become available..."
kubectl rollout status deployment/app -n app --timeout=180s

echo "==> All resources deployed successfully."
echo "See INSTRUCTION.md for how to validate the setup."