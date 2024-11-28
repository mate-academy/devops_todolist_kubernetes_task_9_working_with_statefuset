#!/bin/bash

# Function to check the status of a resource
check_status() {
  local resource_type=$1
  local namespace=$2
  local resource_name=$3

  echo "Checking $resource_type $resource_name in namespace $namespace..."

  if kubectl get "$resource_type" "$resource_name" -n "$namespace" &>/dev/null; then
    echo "$resource_type $resource_name exists in namespace $namespace."
  else
    echo "$resource_type $resource_name does NOT exist in namespace $namespace."
    exit 1
  fi
}

# Validate MySQL
check_status statefulset mysql mysql
check_status pod mysql mysql-0
check_status svc mysql mysql-headless

# Validate ToDo Application
check_status deployment todoapp todoapp
if kubectl get pods -l app=todoapp -n todoapp &>/dev/null; then
  echo "Pod with label app=todoapp exists in namespace todoapp."
else
  echo "Pod with label app=todoapp does NOT exist in namespace todoapp."
  exit 1
fi
check_status svc todoapp todoapp-service

echo "All validations passed successfully."
