#!/usr/bin/env bash
# Stop if a command fails, an unset variable is used, or a pipeline command fails.
set -euo pipefail

# Use a local image loaded directly into kind instead of pulling it from a registry.
CLUSTER_NAME="kind"
IMAGE="todoapp:local"

# Check that all tools needed by this script are installed.
command -v docker >/dev/null
command -v kind >/dev/null
command -v kubectl >/dev/null

# Create the cluster only if it does not already exist, then select its context.
if ! kind get clusters | grep -qx "$CLUSTER_NAME"; then
  kind create cluster --name "$CLUSTER_NAME" --config cluster.yml
fi
kubectl config use-context "kind-$CLUSTER_NAME"

# Build the app image and make it available to every node in the kind cluster.
docker build -t "$IMAGE" ./src
kind load docker-image "$IMAGE" --name "$CLUSTER_NAME"

# Create MySQL configuration and networking before starting the StatefulSet.
kubectl apply -f .infrastructure/mysqlNamespace.yml
kubectl apply -f .infrastructure/mysqlSecret.yml
# Generate the ConfigMap from init.sql so the SQL file remains the source of truth.
kubectl create configmap mysql \
  --from-file=init.sql=.infrastructure/init.sql \
  --namespace=mysql \
  --dry-run=client \
  -o yaml | kubectl apply -f -
kubectl apply -f .infrastructure/mysqlServices.yml
kubectl apply -f .infrastructure/statefulSet.yml

# Wait until all MySQL replicas are ready before deploying the application.
kubectl -n mysql rollout status statefulset/mysql --timeout=600s

# Create app storage, configuration, Secret, Deployment, and access Services.
kubectl apply -f .infrastructure/namespace.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/deployment.yml
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl -n todoapp rollout status deployment/todoapp --timeout=300s

# Show the resulting Pods and persistent volumes.
kubectl get pods -n mysql
kubectl get pods -n todoapp
kubectl get pvc -A