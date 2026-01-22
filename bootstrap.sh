#!/bin/bash
#Create k8s cluster
kind create cluster --config=cluster.yml
kind export kubeconfig --name kind
#Create namespaces for the todoapp and mysql services
kubectl apply -f .infrastructure/services/mysql/mysql-namespace.yml
kubectl apply -f .infrastructure/services/todoapp/todoapp-namespace.yml
#Create service for the todoapp and mysql
kubectl apply -f .infrastructure/services/todoapp/todoapp-service.yml
kubectl apply -f .infrastructure/services/mysql/mysql-st-service.yml
#Create nodePort service for the todoapp
kubectl apply -f .infrastructure/services/todoapp/todoapp-nodeport.yml
#Create secrets for the todoapp and mysql
kubectl apply -f .infrastructure/services/todoapp/todoapp-secret.yml
kubectl apply -f .infrastructure/services/mysql/mysql-secret.yml
kubectl apply -f .infrastructure/services/todoapp/mysql-secret.yml
#Apply configMap for the todoapp and mysql service
kubectl apply -f .infrastructure/services/todoapp/todoapp-configMap.yml
kubectl apply -f .infrastructure/services/mysql/mysql-configMap.yml
#Create PV and PVC for the todoapp
kubectl apply -f .infrastructure/services/todoapp/todoapp-pv.yml
kubectl apply -f .infrastructure/services/todoapp/todoapp-pvc.yml
#Apply statefulset for the mysql
kubectl apply -f .infrastructure/services/mysql/mysql-statefulSet.yml
#Wait till at least one db pod is running and ready
kubectl get pods -n mysql
##Apply deployment to start todoapp
kubectl apply -f .infrastructure/services/todoapp/todoapp-deployment.yml
#Apply HPA manifest for the todoapp
kubectl apply -f .infrastructure/services/todoapp/todoapp-hpa.yml
#access app via browser http://localhost:30007