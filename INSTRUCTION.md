The commands to check that all pods are working:
kubectl get pods -n mysql
kubectl get pods -n todoapp

Connect to MySQL database:
kubectl run mysql-client --image=mysql:8.0 -it -n mysql -- sh
Inside the container, connect to MySQL:
mysql -h mysql-0.mysql -u root --password=1234 -e "SHOW DATABASES"
