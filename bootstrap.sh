#!/bin/bash

kubectl create namespace mysql

kubectl apply -f mysql-secret.yaml

kubectl apply -f statefulSet.yaml

kubectl apply -f todo-db-secret.yaml

kubectl apply -f todo-deployment.yaml

echo "Resources have been deployed successfully."
