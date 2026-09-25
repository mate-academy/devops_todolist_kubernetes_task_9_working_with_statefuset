#!/bin/bash

kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f .infrastructure/