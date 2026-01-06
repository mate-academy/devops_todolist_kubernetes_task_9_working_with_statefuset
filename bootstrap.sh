#!/bin/bash

set -e

kubectl get namespace mysql >/dev/null 2>&1 || kubectl create namespace mysql

echo "Apply headless service..."
kubectl apply -f st-service.yaml

echo "Apply Secret..."
kubectl apply -f st-secret.yaml

echo "Apply ConfigMap..."
kubectl apply -f st-configMap.yaml

echo "Apply StatefulSet..."
kubectl apply -f statefulSet.yaml

echo "All resources successfully applied"
