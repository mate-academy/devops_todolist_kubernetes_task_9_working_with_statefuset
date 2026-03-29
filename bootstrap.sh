#!/bin/bash

cd ./.infrastructure

kubectl apply -f namespace.yml

kubectl apply -f configMap.yml

kubectl apply -f pv.yml

kubectl apply -f pvc.yml

kubectl apply -f deployment.yml

kubectl apply -f mysql-namespace.yml

kubectl apply -f mysql-config.yml

kubectl apply -f mysql-secret.yml

kubectl apply -f mysql-service.yml

kubectl apply -f statefulSet.yml