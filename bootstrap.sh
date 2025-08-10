#!/bin/bash

echo "Creating todoapp and mysql namespaces..."
kubectl apply -f .infrastructure/namespaces.yml

echo "Applying ClusterIp manifest for Deployment..."
kubectl apply -f .infrastrucure/clusterIp.yml

echo "Applying NodePort manifest for Deployment..."
kubectl apply -f .infrastrucure/nodeport.yml

echo "Applying Secret manifest for Deployment..."
kubectl apply -f .infrastrucure/secret.yml

echo "Applying ConfigMap manifest for Deployment..."
kubectl apply -f .infrastrucure/configMap.yml

echo "Applying Secret manifest for StatefulSet..."
kubectl apply -f .infrastrucure/st-secret.yml

echo "Applying ConfigMap manifest for StatefulSet..."
kubectl apply -f .infrastrucure/st-configMap.yml

echo "Applying ClusterIP service manifest for StatefulSet..."
kubectl apply -f .infrastrucure/st-service

echo "Applying StatefulSet manifest..."
kubectl apply -f .infrastrucure/clusterIp.yml

echo "Applying Deployment manifest..."
kubectl apply -f .infrastrucure/deployment.yml

echo "Applying HorizontalPodAutoscaler manifest for Deployment..."
kubectl apply -f .infrastrucure/clusterIp.yml
