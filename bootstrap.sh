#!/bin/bash
set -euo pipefail

CLUSTER_NAME="todoapp"

if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Kind cluster ${CLUSTER_NAME} already exists."
else
  kind create cluster --name "${CLUSTER_NAME}" --config cluster.yml
fi

kubectl apply -f .infrastructure/namespace.yml

kubectl apply -f .infrastructure/secret-mysql.yaml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
