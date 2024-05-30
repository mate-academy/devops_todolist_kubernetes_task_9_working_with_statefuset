#!/bin/bash

# Step 1: Create a Kind cluster from a configuration file
kind create cluster --config cluster.yml

# Step 2: Apply all Kubernetes manifests in the infrastructure directory
kubectl apply -f infrastructure/
