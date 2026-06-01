#!/bin/bash
kubectl create namespace mysql --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/service.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl create configmap mysql-init-script --from-file=init.sql -n mysql --dry-run=client -o yaml | kubectl apply -f -