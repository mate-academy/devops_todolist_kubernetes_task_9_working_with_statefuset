
#!/bin/bash

# Create MySQL namespace
kubectl apply -f .infrastructure/mysqlNamespace.yml

# Create TodoApp namespace
kubectl apply -f .infrastructure/namespace.yml

# Create MySQL Service
kubectl apply -f .infrastructure/headlessService.yml

# Create MySQL ConfigMap
kubectl apply -f .infrastructure/mysqlConfigMap.yml

# Create MySQL Secret
kubectl apply -f .infrastructure/mysqlSecret.yml

# Create TodoApp Secret
kubectl apply -f .infrastructure/secret.yml

# Create MySQL StatefulSet
kubectl apply -f .infrastructure/statefulset.yml

#Create Todoapp Service
kubectl apply -f .infrastructure/nodeport.yml

#Create Todoapp PV
kubectl apply -f .infrastructure/pv.yml

#Create Todoapp PVC
kubectl apply -f .infrastructure/pvc.yml

#Create Todoapp Deployment
kubectl apply -f .infrastructure/deployment.yml
