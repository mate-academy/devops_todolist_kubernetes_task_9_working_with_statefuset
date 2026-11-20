#!/bin/bash
set -euo pipefail

# Run from the repository root, regardless of the current working directory.
cd "$(dirname "$0")"

CLUSTER_NAME="task9"
KUBE_CONTEXT="kind-${CLUSTER_NAME}"
INFRA_DIR=".infrastructure"
DJANGO_IMAGE="todoapp:task9"

log() {
  printf '\n==> %s\n' "$1"
}

for command_name in docker kind kubectl; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Error: '$command_name' is not installed or not in PATH." >&2
    exit 1
  fi
done

if ! docker info >/dev/null 2>&1; then
  echo "Error: Docker is not running. Start Docker Desktop first." >&2
  exit 1
fi

for required_file in \
  "$INFRA_DIR/cluster.yml" \
  "$INFRA_DIR/st-service.yml" \
  "$INFRA_DIR/st-secret.yml" \
  "$INFRA_DIR/st-configMap.yml" \
  "$INFRA_DIR/statefulSet.yml" \
  "$INFRA_DIR/secret.yml" \
  "$INFRA_DIR/deployment.yml" \
  "src/Dockerfile" \
  "src/requirements.txt"; do
  if [[ ! -f "$required_file" ]]; then
    echo "Error: Required file is missing: $required_file" >&2
    exit 1
  fi
done

log "1/8: Ensure kind cluster '${CLUSTER_NAME}' exists"
if kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
  echo "Cluster '${CLUSTER_NAME}' already exists; reusing it."
else
  kind create cluster \
    --name "$CLUSTER_NAME" \
    --config "$INFRA_DIR/cluster.yml" \
    --wait 180s
fi

# Always specify the target context to avoid deploying to Docker Desktop Kubernetes.
k() {
  kubectl --context "$KUBE_CONTEXT" "$@"
}

log "2/8: Wait for Kubernetes nodes"
k wait --for=condition=Ready nodes --all --timeout=240s

log "3/8: Create required namespaces (if absent)"
for ns in mysql todoapp; do
  k create namespace "$ns" --dry-run=client -o yaml | k apply -f -
done

log "4/8: Apply MySQL Secret, ConfigMap, headless Service, and StatefulSet"
k apply -f "$INFRA_DIR/st-secret.yml"
k apply -f "$INFRA_DIR/st-configMap.yml"
k apply -f "$INFRA_DIR/st-service.yml"
k apply -f "$INFRA_DIR/statefulSet.yml"
k -n mysql rollout status statefulset/mysql --timeout=600s

log "5/8: Build Django image and load it into kind"
docker build -t "$DJANGO_IMAGE" ./src
kind load docker-image "$DJANGO_IMAGE" --name "$CLUSTER_NAME"

log "6/8: Deploy Django with database configuration from the app Secret"
k apply -f "$INFRA_DIR/secret.yml"
k apply -f "$INFRA_DIR/deployment.yml"
# A fixed local tag is rebuilt on each run, so restart pods to load the latest image.
k -n todoapp rollout restart deployment/todoapp
k -n todoapp rollout status deployment/todoapp --timeout=300s

log "7/8: Apply Django database migrations"
k -n todoapp exec deployment/todoapp -- python manage.py migrate --noinput

log "8/8: Show deployment status"
k -n mysql get statefulset,pods,pvc,svc
k -n todoapp get deployment,pods

printf '\nDeployment finished.\n'
printf 'Open the Django app using:\n'
printf '  kubectl --context %s -n todoapp port-forward deployment/todoapp 8080:8080\n' "$KUBE_CONTEXT"
printf 'Validation commands are documented in INSTRUCTION.md.\n'
