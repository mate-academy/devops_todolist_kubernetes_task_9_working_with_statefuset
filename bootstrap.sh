#!/bin/bash

kind create cluster --config cluster.yml
kubectl apply -f mysql-configMap.yml
kubectl apply -f mysql-secret.yaml
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f statefulset.yaml
kubectl apply -f secret.yml
kubectl apply -f deployment.yaml