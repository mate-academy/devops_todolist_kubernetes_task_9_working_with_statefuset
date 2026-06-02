#!/bin/bash

kubectl apply -f statefulset-service.yml
kubectl apply -f stateful-set-secret.yml
kubectl apply -f ConfigMap-Statefulset.yml
kubectl apply -f statefulSet.yml
kubectl apply -f secret.yml
kubectl apply -f deployment.yml