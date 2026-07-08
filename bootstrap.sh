#!/bin/bash
set -e

kind create cluster --config cluster.yml --name todoapp-cluster

kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f .infrastructure/configmap.yml
kubectl apply -f .infrastructure/secret.yml

kubectl apply -f .infrastructure/mysql-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl rollout status statefulset/todoapp-mysql -n mysql --timeout=120s

kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/todoapp_pod.yml # ИСПРАВЛЕНО ИМЯ ФАЙЛА
