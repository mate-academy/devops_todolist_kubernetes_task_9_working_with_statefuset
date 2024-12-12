In order to validate the changes:

kubectl get pods -n mysql
kubectl describe -n mysql pod <pod-name>

kubectl get statefulsets -n mysql
kubectl get svc -n mysql

kubectl get pods -n todoapp
kubectl get deployment -n todoapp
