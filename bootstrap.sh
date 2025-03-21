#!/bin/bash

cd .infrastructure
kubectl create ns mysql
kubectl apply -f namespace.yml
kubectl apply -f confgiMap.yml
kubectl apply -f configmap-initdb.yml
kubectl apply -f secret.yml
kubectl apply -f mysql-secrets.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f clusterIp.yml
kubectl apply -f nodeport.yml
kubectl apply -f hpa.yml
kubectl apply -f headless.yml
kubectl apply -f statefulSet.yml
kubectl apply -f deployment.yml
