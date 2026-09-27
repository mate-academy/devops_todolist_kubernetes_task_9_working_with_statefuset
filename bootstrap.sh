#!/bin/bash
set -euo pipefail

# Cluster
kind create cluster --config cluster.yml
# Namespace
kubectl apply -f .infrastructure/namespace.yml

# StatefulSet and services
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml