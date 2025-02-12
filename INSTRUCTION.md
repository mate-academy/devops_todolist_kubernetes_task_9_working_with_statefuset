# Instructions on how to how to validate the changes:
# Deploy the resources:
./bootstrap.sh

# Check the Pods:
kubectl get pods -n todoapp
kubectl get pods -n mysql
# How to check database changes:
kubectl run -it --rm --image=mysql:8.0 --restart=Never --namespace=mysql mysql-client -- sh
# after than in sh console put:
mysql -u todoappuser -p1234 -h mysql-0.mysql-headless
# after than in mysql console put:
SHOW DATABASES;
USE tododb;
SHOW TABLES;
SELECT * FROM  lists_todo;
