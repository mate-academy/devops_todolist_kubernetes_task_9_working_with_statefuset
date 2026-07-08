#!/bin/bash
set -e

kind create cluster --config cluster.yml --name todoapp-cluster

kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f mysql-init-config.yml

kubectl apply -f mysql-secret.yml
kubectl apply -f mysql.yml

kubectl rollout status statefulset/todoapp-mysql -n mysql

kubectl apply -f app-config.yml -n todoapp
kubectl apply -f todoapp-secret.yml
kubectl apply -f deployment.yml
