#!/bin/bash
set -euo pipefail

kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/configMap.yml

kubectl apply -f .infrastructure/statefulSet.yml

kubectl apply -f .infrastructure/pv.yml

kubectl apply -f .infrastructure/deployment.yml