#!/usr/bin/env bash
# Deploys the ToDo app + MySQL StatefulSet to a local kind cluster.
# Run from the repository root: ./bootstrap.sh
set -euo pipefail

INFRA_DIR=".infrastructure"

# 1. Cluster
if ! kind get clusters 2>/dev/null | grep -qx "kind"; then
  kind create cluster --config "$INFRA_DIR/cluster.yml"
else
  echo "kind cluster already exists, skipping creation"
fi

# 2. Namespaces (todoapp, mysql)
kubectl apply -f "$INFRA_DIR/namespace.yml"

# 3. MySQL: secret, init.sql ConfigMap, headless Service, StatefulSet
kubectl apply -f "$INFRA_DIR/st-secret.yml"
kubectl apply -f "$INFRA_DIR/st-configMap.yml"
kubectl apply -f "$INFRA_DIR/st-service.yml"
kubectl apply -f "$INFRA_DIR/statefulSet.yml"

# Wait until all 3 MySQL pods are ready (they start one by one)
kubectl rollout status statefulset/mysql -n mysql --timeout=600s

# 4. ToDo app: config, secret, storage, deployment, services, autoscaler
kubectl apply -f "$INFRA_DIR/configMap.yml"
kubectl apply -f "$INFRA_DIR/secret.yml"
kubectl apply -f "$INFRA_DIR/pv.yml"
kubectl apply -f "$INFRA_DIR/pvc.yml"
kubectl apply -f "$INFRA_DIR/deployment.yml"
kubectl apply -f "$INFRA_DIR/clusterIp.yml"
kubectl apply -f "$INFRA_DIR/nodeport.yml"
kubectl apply -f "$INFRA_DIR/hpa.yml"

kubectl rollout status deployment/todoapp -n todoapp --timeout=300s

echo
echo "Deployment finished. App: http://localhost:30007"
kubectl get pods -n mysql
kubectl get pods -n todoapp
