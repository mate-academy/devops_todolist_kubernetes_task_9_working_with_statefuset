#!/bin/bash

kind create cluster --config cluster.yml &&

kubectl create ns todoapp &&
kubectl create ns mysql &&

kubectl apply -f .infrastructure/pv.yml -n todoapp &&
kubectl apply -f .infrastructure/pvc.yml -n todoapp &&
kubectl apply -f .infrastructure/confgiMap.yml -n todoapp &&
kubectl apply -f .infrastructure/secret.yml -n todoapp &&
kubectl apply -f .infrastructure/deployment.yml -n todoapp &&

kubectl apply -f .infrastructure/configMapMysql.yml -n mysql &&
kubectl apply -f .infrastructure/headless_service.yml -n mysql &&
kubectl apply -f .infrastructure/mysql_secret.yml -n mysql &&
kubectl apply -f .infrastructure/statefulSet.yml -n mysql
