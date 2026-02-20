#!/bin/bash
set -euo pipefail

CLUSTER_NAME="todoapp"

if ! kind get clusters | grep -qx "${CLUSTER_NAME}"; then
  kind create cluster --name "${CLUSTER_NAME}" --config cluster.yml
fi

kubectl apply -f .infrastructure/namespace.yml

kubectl -n mysql create configmap mysql-init-sql \
  --from-file=init.sql=.infrastructure/init.sql \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-service.yml

kubectl rollout restart statefulset/mysql -n mysql
kubectl rollout status statefulset/mysql -n mysql --timeout=300s

kubectl apply -f .infrastructure/confgiMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml

kubectl rollout status deployment/todoapp -n todoapp --timeout=300s
