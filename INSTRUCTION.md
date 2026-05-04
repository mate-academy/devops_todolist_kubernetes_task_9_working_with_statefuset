 Validation Instructions
## Prerequisites
- kind installed
- kubectl installed
- Docker running


## Deploy
```bash
./bootstrap.sh
Validate

Check namespace:

kubectl get ns mysql

Check StatefulSet:

kubectl get statefulset -n mysql
kubectl describe statefulset mysql -n mysql

Check pods:

kubectl get pods -n mysql

Check services:

kubectl get svc -n mysql

Check secrets:

kubectl get secrets -n mysql

Test MySQL connection:

kubectl exec -it mysql-0 -n mysql -- mysql -u root -p

Check app deployment:

kubectl get deployment -n mysql
kubectl get pods -n mysql -l app=todoapp
Cleanup
kubectl delete namespace mysql
kind delete cluster