# How to run the project

1. Create the Kubernetes cluster:

kind create cluster --config cluster.yml

2. Deploy all resources:

bash bootstrap.sh

3. Check MySQL:

kubectl get pods -n mysql
kubectl get pvc -n mysql
kubectl get statefulset -n mysql

4. Check the ToDo application:

kubectl get pods -n todoapp

5. Forward the application port:

kubectl port-forward service/todoapp-nodeport 8080:80 -n todoapp

6. Open the application:

http://localhost:8080
