#!/bin/bash
set -e

if ! kind get clusters 2>/dev/null | grep -q "^kind$"; then
  cat <<'EOF' | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraMounts:
    - hostPath: /tmp
      containerPath: /data
  extraPortMappings:
  - containerPort: 30007
    hostPort: 30007
EOF
fi

kubectl apply -f .infrastructure/statefulSet.yml

kubectl wait --for=condition=ready pod -l app=mysql -n mysql --timeout=300s

kubectl apply -f .infrastructure/db-secret.yml
kubectl apply -f .infrastructure/deployment.yml

kubectl wait --for=condition=ready pod -l app=todoapp -n todoapp --timeout=300s

echo "Deployment completed successfully"
