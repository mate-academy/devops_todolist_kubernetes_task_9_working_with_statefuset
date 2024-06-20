#!/bin/bash

kind delete cluster
kind create cluster --config .infrastructure/cluster.yml
kubectl apply -f .\.infrastructure\namespace.yml
kubectl apply -f .\.infrastructure\confgiMap.yml
kubectl apply -f .\.infrastructure\secret.yml
kubectl apply -f .\.infrastructure\clusterIp.yml
kubectl apply -f .\.infrastructure\nodeport.yml
kubectl apply -f .\.infrastructure\pv.yml
kubectl apply -f .\.infrastructure\pvc.yml
kubectl apply -f .\.infrastructure\statefulSet.yml
kubectl apply -f .\.infrastructure\deployment.yml
kubectl apply -f .\.infrastructure\hpa.yml