#!/bin/bash

kind create cluster --config cluster.yml

kubectl create namespace mysql
kubectl create namespace todoapp

kubectl apply -f .infrastructure/st-secret.yml -n mysql
kubectl apply -f .infrastructure/st-configMap.yml -n mysql
kubectl apply -f .infrastructure/st-service.yml -n mysql
kubectl apply -f .infrastructure/statefulSet.yml -n mysql

kubectl apply -f .infrastructure/app-secret.yml -n todoapp
kubectl apply -f .infrastructure/app-config.yml -n todoapp
kubectl apply -f .infrastructure/app-db-secrets.yml -n todoapp
kubectl apply -f .infrastructure/deployment.yml -n todoapp