#!/bin/bash

# run mysql DB statefulSet

kubectl create ns mysql

cd ./.infrastructure/ && kubectl apply -f st_configMap.yml -n mysql

kubectl apply -f st_secret.yml -n mysql

kubectl apply -f st_service.yml -n mysql

kubectl apply -f statefulSet.yml -n mysql


# run todolist application

cd ./.infrastructure/ && kubectl apply -f namespace.yml

kubectl apply -f clusterIp.yml -n todoapp

kubectl apply -f nodeport.yml -n todoapp

kubectl apply -f secret.yml -n todoapp

kubectl apply -f configMap.yml -n todoapp

kubectl apply -f hpa.yml -n todoapp

kubectl apply -f pv.yml -n todoapp

kubectl apply -f pvc.yml -n todoapp


# run the database migrations

kubectl apply -f job.yml -n todoapp


# run the deployment

kubectl apply -f deployment.yml -n todoapp