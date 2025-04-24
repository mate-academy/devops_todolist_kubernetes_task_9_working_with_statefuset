# Instructions for Deploying and Validating MySQL StatefulSet with Application
## Deploying Resources Using bootstrap.sh
The bootstrap.sh script contains all commands to deploy the required Kubernetes resources, including the MySQL namespace, Secret, StatefulSet, headless Service, and the application.

Run the script
`./bootstrap.sh`
## Validate the Deployment
### To Check that the MySQL StatefulSet pods are running, run
```kubectl get pods -n mysql```
### To Confirm that StatefulSet is correctly configured, run
```kubectl get statefulset -n mysql```
### To Check that the headless Service is created, run
```kubectl get svc -n mysql```
### To Verify Database Initialization
To verify that that tables are created, run such commands
```
kubectl exec -it mysql-0 -n mysql -- sh
mysql -u root --password(password is 1234)
SHOW TABLES FROM app_db;
```
### Verify Persistent Storage
To check that Persistent Volume Claims are created for each pod, run
```kubectl get pvc -n mysql```