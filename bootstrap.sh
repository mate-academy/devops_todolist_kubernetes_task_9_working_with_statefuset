#!/bin/bash
kubectl apply -f statefulset.yml
kubectl apply -f configmap-initdb.yml
kubectl apply -f deployment.yml
