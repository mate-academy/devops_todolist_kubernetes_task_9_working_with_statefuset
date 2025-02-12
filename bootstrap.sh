#!/bin/bash

set -e  # Прерывать выполнение при ошибке

# Применение namespace
echo "Apply namespace..."
kubectl apply -f .infrastructure/namespace.yml
echo "Apply namespace..."
kubectl apply -f .infrastructure/clusterIp.yml

# Применение всех файлов, кроме statefulSet.yml и deployment.yml
echo "Apply other configurations..."
for file in .infrastructure/*.yml; do
  if [[ $file != *"statefulSet.yml" && $file != *"deployment.yml" &&\
   $file != *"cluster.yml" && $file != *"kustomization.yml" ]]; then
    echo "Apply $file..."
    kubectl apply -f "$file"
  fi
done

# Применение StatefulSet и ожидание его готовности
echo "Apply StatefulSet and waiting for readiness..."
kubectl apply -f .infrastructure/statefulSet.yml

# Ожидание готовности StatefulSet
echo "Waiting for readiness StatefulSet..."
kubectl rollout status statefulset mysql -n mysql --timeout=300s

# Применение Deployment
echo "Apply Deployment..."
kubectl apply -f .infrastructure/deployment.yml

echo "Deployment success!"