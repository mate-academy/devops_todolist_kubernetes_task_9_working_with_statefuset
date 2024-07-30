#!/bin/bash

kind create cluster --config=cluster.yml

kubectl apply -f statefulSet.yml

kubectl create namespace todoapp
kubectl apply -f deployment.yml