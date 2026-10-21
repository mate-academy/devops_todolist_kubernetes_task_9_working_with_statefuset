#!/bin/bash
set -e

# 1. Kind cluster
kind get clusters | grep -qx todoapp || kind create cluster --name todoapp --config cluster.yml
kubectl cluster-info --context kind-todoapp

# 2. Namespaces
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

# 3. MySQL: secret, init.sql as ConfigMap, headless service + StatefulSet
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl create configmap mysql-init --from-file=init.sql -n mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f .infrastructure/statefulSet.yml
kubectl rollout status statefulset/mysql -n mysql --timeout=300s

# 4. Application: ConfigMap, Secrets, PV, PVC, Deployment
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/db-secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl rollout status deployment/todoapp -n todoapp --timeout=300s

kubectl get pods -A