#!/bin/bash

echo "Creating Kubernetes cluster using kind with extra Mount"
kind create cluster --config cluster.yml

echo "Creating namespaces"
kubectl apply -f ./.infrastructure/namespace.yml

echo "Creating other manifests"
kubectl apply -f ./.infrastructure/pv.yml
kubectl apply -f ./.infrastructure/pvc.yml
kubectl apply -f ./.infrastructure/secret.yml
kubectl apply -f ./.infrastructure/configMap.yml
kubectl apply -f ./.infrastructure/headless-svc.yml
kubectl apply -f ./.infrastructure/st-secret.yml
kubectl apply -f ./.infrastructure/st-configMap.yml
kubectl apply -f ./.infrastructure/statefulSet.yml
kubectl apply -f ./.infrastructure/clusterIp.yml
kubectl apply -f ./.infrastructure/nodeport.yml

kubectl -n mysql wait --for=condition=ready pod -l app=mysql --timeout=300s

kubectl apply -f ./.infrastructure/hpa.yml
kubectl apply -f ./.infrastructure/deployment.yml

echo "Done!"
