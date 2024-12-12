# Persistent Volumes and Stateful Sets for TodoApp
## 1. Create a Kind cluster:
```bash
kind create cluster --config cluster.yml
```
This command will create a new Kind cluster based on the cluster.yml configuration file. You will automatically be switched to the new cluster if the command is successful.

## 2. Deploy the app and additional resources.
```bash
./bootstrap.sh
```
This script will create all necessary namespaces and apply the required manifests for both the app and the database.

## 3. Check if environment variables were saved successfully:
```bash
kubectl get pods -n todoapp
kubectl exec -it todoapp <pod-name> -n todoapp -- printenv | grep -E 'DB_NAME|DB_USER|DB_PASSWORD|DB_HOST'
```
This will check if the environment variables for the database connection (DB_NAME, DB_USER, DB_PASSWORD, DB_HOST) are set correctly in the TodoApp pod.

## 4. Verify the StatefulSet and its pods:
```bash
kubectl exec -it mysql-0 -n mysql -- sh
kubectl get pods -n mysql -o wide
```
You should see 3 replicas with pod names mysql-0, mysql-1, and mysql-2 in the mysql namespace.

## 5. Check the #0 pod of the StatefulSet and see the tables:
```bash
kubectl exec -it mysql-0 -n mysql -- mysql -h mysql-0 -u root --password=myrootpw -e "SHOW DATABASES;"
```