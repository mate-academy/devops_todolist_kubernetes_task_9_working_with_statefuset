#!/bin/bash

echo "Spinning up Kind cluster..."
kind create cluster --config cluster.yml

echo "Creating namespaces..."
kubectl apply -f .infrastructure/mysql-namespace.yml
kubectl apply -f .infrastructure/namespace.yml

echo "Deploying MySQL Database Architecture..."
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init-config.yml
kubectl apply -f .infrastructure/statefulSet.yml

echo "Deploying Application Components..."
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/app-db-secret.yml
kubectl apply -f .infrastructure/deployment.yml

echo "Infrastructure deployment triggered successfully!"
