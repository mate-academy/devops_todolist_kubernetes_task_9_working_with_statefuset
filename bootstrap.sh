
#!/bin/bash

set -e

echo "=== Creating kind cluster ==="

if ! kind get clusters | grep -q "^kind$"; then
    kind create cluster --config .infrastructure/cluster.yml
else
    echo "Cluster already exists"
fi

echo "=== Creating namespaces ==="
kubectl apply -f .infrastructure/namespace.yml

echo "=== Applying MySQL configuration ==="
kubectl apply -f .infrastructure/mysql-secret.yml
kubectl apply -f .infrastructure/mysql-init.yml
kubectl apply -f .infrastructure/mysql-service.yml

echo "=== Applying Django configuration ==="
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/db-secret.yml

echo "=== Applying storage ==="
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml

echo "=== Deploying MySQL ==="
kubectl apply -f .infrastructure/statefulSet.yml

echo "=== Waiting for MySQL ==="
kubectl rollout status statefulset/mysql -n mysql --timeout=240s

echo "=== Deploying Django ==="
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml

echo "=== Applying NodePort service ==="
kubectl apply -f .infrastructure/nodeport.yml

echo "=== Applying Horizontal Pod Autoscaler ==="
kubectl apply -f .infrastructure/hpa.yml

echo "=== Waiting for Django ==="
kubectl rollout status deployment/todoapp -n todoapp --timeout=180s

echo "=== Checking resources ==="
kubectl get pods -n mysql
kubectl get pods -n todoapp

echo "=== Deployment completed ==="
