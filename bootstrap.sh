#!/bin/bash

kind create cluster --config=cluster.yml

kubectl create namespace mysql

kubectl apply -f ./.infrastructure/statefulSet.yml

kubectl apply -f ./.infrastructure/secret.yml
kubectl apply -f ./.infrastructure/mysql-secret.yml

kubectl apply -f ./.infrastructure/deployment.yml
