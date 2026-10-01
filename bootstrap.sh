#!/usr/bin/env bash

set -euo pipefail

CLUSTER_NAME="todo-cluster"
APP_IMAGE="todoapp:task9"

if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  kind create cluster --name "${CLUSTER_NAME}" --config cluster.yml
fi

kubectl config use-context "kind-${CLUSTER_NAME}"

docker build -t "${APP_IMAGE}" ./src
kind load docker-image "${APP_IMAGE}" --name "${CLUSTER_NAME}"

kubectl apply -f .infrastructure/namespace.yml

kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/mysql-init.yml
kubectl apply -f .infrastructure/mysql-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/app-secret.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml

kubectl rollout restart deployment/todoapp -n todoapp
kubectl rollout status statefulset/mysql -n mysql --timeout=5m
kubectl rollout status deployment/todoapp -n todoapp --timeout=5m

echo "ToDo app is ready: http://localhost:30007"
