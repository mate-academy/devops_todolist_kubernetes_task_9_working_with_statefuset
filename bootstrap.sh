#!/bin/bash

kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kind load docker-image todoapp:3.0.0
kubectl apply -f .infrastructure/