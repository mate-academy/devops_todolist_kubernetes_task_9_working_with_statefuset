#!/bin/bash

set -euo pipefail

CLUSTER_NAME="todoapp"
INFRA_DIR=".infrastructure"
APP_IMAGE="volodymyrlp/todoapp:4.0.0"


if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  echo ">> Creating kind cluster '${CLUSTER_NAME}'..."
  kind create cluster --name "${CLUSTER_NAME}" --config cluster.yml
else
  echo ">> kind cluster '${CLUSTER_NAME}' already exists, reusing it."
fi


echo ">> Building app image '${APP_IMAGE}'..."
docker build -t "${APP_IMAGE}" ./src
echo ">> Loading image into kind cluster..."
kind load docker-image "${APP_IMAGE}" --name "${CLUSTER_NAME}"


echo ">> Deploying MySQL StatefulSet..."
kubectl apply -f "${INFRA_DIR}/mysql/namespace.yml"
kubectl apply -f "${INFRA_DIR}/mysql/secret.yml"
kubectl apply -f "${INFRA_DIR}/mysql/init-configmap.yml"
kubectl apply -f "${INFRA_DIR}/mysql/statefulSet.yml"

echo ">> Waiting for MySQL pods to become ready..."
kubectl rollout status statefulset/mysql -n mysql --timeout=300s


echo ">> Deploying ToDo application..."
kubectl apply -f "${INFRA_DIR}/namespace.yml"
kubectl apply -f "${INFRA_DIR}/secret.yml"
kubectl apply -f "${INFRA_DIR}/db-secret.yml"
kubectl apply -f "${INFRA_DIR}/configMap.yml"
kubectl apply -f "${INFRA_DIR}/pv.yml"
kubectl apply -f "${INFRA_DIR}/pvc.yml"
kubectl apply -f "${INFRA_DIR}/deployment.yml"
kubectl apply -f "${INFRA_DIR}/clusterIp.yml"
kubectl apply -f "${INFRA_DIR}/nodeport.yml"
kubectl apply -f "${INFRA_DIR}/hpa.yml"

echo ">> Waiting for the application rollout to finish..."
kubectl rollout status deployment/todoapp -n todoapp --timeout=300s

echo ">> Done. The app is reachable via the NodePort on http://localhost:30007/"
