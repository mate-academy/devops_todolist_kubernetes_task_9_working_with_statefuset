#!/bin/bash

kind create cluster --config cluster.yml
kubectl create ns mysql
kubectl apply -f .infrastructure/mysqlSecrets.yml
kubectl apply -f .infrastructure/mysqlConfigMap.yml
kubectl apply -f .infrastructure/services.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/deployment.yml