#!/bin/bash
kind create cluster --config cluster.yml
kubectl create ns todoapp
kubectl create ns mysql
kubectl apply -f .infrastructure/service.yml
kubectl apply -f .infrastructure/configMapDB.yml
kubectl apply -f .infrastructure/secretDB.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/deployment.yml