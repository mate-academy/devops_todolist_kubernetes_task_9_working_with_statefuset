#!/bin/bash

echo "Creating todoapp and mysql namespaces..."
kubectl apply -f .infrastructure/namespaces.yml

echo "Applying ClusterIp manifest for Deployment..."
kubectl apply -f .infrastructure/clusterIp.yml

echo "Applying NodePort manifest for Deployment..."
kubectl apply -f .infrastructure/nodeport.yml

echo "Applying Secret manifest for Deployment..."
kubectl apply -f .infrastructure/secret.yml

echo "Applying ConfigMap manifest for Deployment..."
kubectl apply -f .infrastructure/configMap.yml

echo "Applying Secret manifest for StatefulSet..."
kubectl apply -f .infrastructure/st-secret.yml

echo "Applying ConfigMap manifest for StatefulSet..."
kubectl apply -f .infrastructure/st-configMap.yml

echo "Applying ClusterIP service manifest for StatefulSet..."
kubectl apply -f .infrastructure/st-service.yml

echo "Applying StatefulSet manifest..."
kubectl apply -f .infrastructure/statefulSet.yml

echo "Applying Deployment manifest..."
kubectl apply -f .infrastructure/deployment.yml

echo "Applying HorizontalPodAutoscaler manifest for Deployment..."
kubectl apply -f .infrastructure/hpa.yml
