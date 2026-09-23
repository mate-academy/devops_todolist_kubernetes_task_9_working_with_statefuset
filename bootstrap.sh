#!/bin/bash

files=(
    "namespace.yml"
    "secret.yml"
    "configMap.yml"
    "configMapMysql.yml"
    "pv.yml"
    "pvc.yml"
    "deployment.yml"
    "mysqlHeadless.yml"
    "statefulSet.yml"
    "nodeport.yml"
    "clusterIp.yml"
    "hpa.yml"
) 

for file in "${files[@]}"; do
    kubectl apply -f .infrastructure/$file
done

