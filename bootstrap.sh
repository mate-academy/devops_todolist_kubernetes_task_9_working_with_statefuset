#!/bin/bash

ST_NAMESPACE_FILE=".infrastructure/st-namespace.yml"
ST_CONFIGMAP_FILE=".infrastructure/st-configMap.yml"
ST_SECRET_FILE=".infrastructure/st-secret.yml"
ST_SERVICE_FILE=".infrastructure/st-service.yml"
STATEFULSET_FILE=".infrastructure/statefulSet.yml"

CLUSTER_FILE=".infrastructure/cluster.yml"
NAMESPACE_FILE=".infrastructure/namespace.yml"
CLUSTERIP_FILE=".infrastructure/clusterIp.yml"
NODEPORT_FILE=".infrastructure/nodeport.yml"
CONFIGMAP_FILE=".infrastructure/configMap.yml"
SECRET_FILE=".infrastructure/secret.yml"
PV_FILE=".infrastructure/pv.yml"
PVC_FILE=".infrastructure/pvc.yml"
DEPLOYMENT_FILE=".infrastructure/deployment.yml"
HPA_FILE=".infrastructure/hpa.yml"

if [ ! -f "$STATEFULSET_FILE" ]; then
    echo "The file $STATEFULSET_FILE is not found"
    exit 1
fi

if [ ! -f "$ST_SERVICE_FILE" ]; then
    echo "The file $ST_SERVICE_FILE is not found"
    exit 1
fi

if [ ! -f "$ST_SECRET_FILE" ]; then
    echo "The file $ST_SECRET_FILE is not found"
    exit 1
fi

if [ ! -f "$ST_CONFIGMAP_FILE" ]; then
    echo "The file $ST_CONFIGMAP_FILE is not found"
    exit 1
fi

if [ ! -f "$ST_NAMESPACE_FILE" ]; then
    echo "The file $ST_NAMESPACE_FILE is not found"
    exit 1
fi

if [ ! -f "$CLUSTER_FILE" ]; then
    echo "The file $CLUSTER_FILE is not found"
    exit 1
fi

if [ ! -f "$NAMESPACE_FILE" ]; then
    echo "The file $NAMESPACE_FILE is not found"
    exit 1
fi

if [ ! -f "$CLUSTERIP_FILE" ]; then
    echo "The file $CLUSTERIP_FILE is not found"
    exit 1
fi

if [ ! -f "$NODEPORT_FILE" ]; then
    echo "The file $NODEPORT_FILE is not found"
    exit 1
fi

if [ ! -f "$CONFIGMAP_FILE" ]; then
    echo "The file $CONFIGMAP_FILE is not found"
    exit 1
fi

if [ ! -f "$SECRET_FILE" ]; then
    echo "The file $SECRET_FILE is not found"
    exit 1
fi

if [ ! -f "$PV_FILE" ]; then
    echo "The file $PV_FILE is not found"
    exit 1
fi

if [ ! -f "$PVC_FILE" ]; then
    echo "The file $PVC_FILE is not found"
    exit 1
fi

if [ ! -f "$DEPLOYMENT_FILE" ]; then
    echo "The file $DEPLOYMENT_FILE is not found"
    exit 1
fi

if [ ! -f "$HPA_FILE" ]; then
    echo "The file $HPA_FILE is not found"
    exit 1
fi

kind create cluster --config "$CLUSTER_FILE"

kubectl apply -f "$ST_NAMESPACE_FILE"
kubectl apply -f "$ST_CONFIGMAP_FILE"
kubectl apply -f "$ST_SECRET_FILE"
kubectl apply -f "$ST_SERVICE_FILE"
kubectl apply -f "$STATEFULSET_FILE"

kubectl apply -f "$NAMESPACE_FILE"
kubectl apply -f "$CLUSTERIP_FILE"
kubectl apply -f "$NODEPORT_FILE"
kubectl apply -f "$CONFIGMAP_FILE"
kubectl apply -f "$SECRET_FILE"
kubectl apply -f "$PV_FILE"
kubectl apply -f "$PVC_FILE"
kubectl apply -f "$DEPLOYMENT_FILE"
kubectl apply -f "$HPA_FILE"

echo "All commands were completed"
