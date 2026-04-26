#!/bin/bash

# Init StatefulSet

kubectl apply -f .infrastructure/namespace-ss.yml

kubectl apply -f .infrastructure/configMap-ss.yml

kubectl apply -f .infrastructure/secret-ss.yml

kubectl apply -f .infrastructure/headlessClusterIp.yml

kubectl apply -f .infrastructure/statefulSet.yml

sleep 10

# Init deployment

kubectl apply -f .infrastructure/namespace.yml

kubectl apply -f .infrastructure/secret.yml

kubectl apply -f .infrastructure/configMap.yml

kubectl apply -f .infrastructure/nodeport.yml

kubectl apply -f .infrastructure/deployment.yml
