#!/bin/bash

kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

cd ./.infrastructure

kubectl apply -f st-service.yml -n mysql
kubectl apply -f st-configmap.yml -n mysql
kubectl apply -f st-secret.yml -n mysql

kubectl apply -f statefulSet.yml -n mysql

kubectl apply -f secret.yml -n todoapp
kubectl apply -f configMap.yml -n todoapp
kubectl apply -f pv.yml -n todoapp
kubectl apply -f pvc.yml -n todoapp
kubectl apply -f deployment.yml -n todoapp

