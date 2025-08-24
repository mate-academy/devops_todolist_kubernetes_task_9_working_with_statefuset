#!/bin/bash

kind create cluster --config=cluster.yml
kubectl apply -f namespace.yml
kubectl apply -f mysql-secret.yml
kubectl apply -f mysql-configmap.yml
kubectl apply -f statefulSet.yml
kubectl apply -f deployment.yml