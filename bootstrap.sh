#!/bin/bash

echo "Creating namespace"

kubectl apply -f .infrastructure/mysql/st-namespace.yml

echo "Starting dns service"

kubectl apply -f .infrastructure/mysql/st-service.yml 

echo "Applying secret"

kubectl apply -f .infrastructure/mysql/st-secret.yml 

echo "Applying config map"

kubectl apply -f .infrastructure/mysql/st-configMap.yml

sleep 3

echo "Starting Stateful Set"

kubectl apply -f .infrastructure/mysql/statefulSet.yml

kubectl apply -f .infrastructure/configMap.yml

kubectl apply -f .infrastructure/secret.yml

kubectl apply -f .infrastructure/pv.yml

sleep 3

kubectl apply -f .infrastructure/pvc.yml

kubectl apply -f .infrastructure/nodeport.yml

kubectl apply -f .infrastructure/clusterIp.yml

kubectl apply -f .infrastructure/hpa.yml

kubectl apply -f .infrastructure/deployment.yml