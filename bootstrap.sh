#!/bin/bash
set -e

kind create cluster --config cluster.yml

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-initdb.yml
kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/app-secret.yml
kubectl apply -f .infrastructure/deployment.yml