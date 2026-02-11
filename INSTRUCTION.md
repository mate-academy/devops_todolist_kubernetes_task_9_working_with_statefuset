## Validation & Verification Guide
This guide provides step-by-step instructions to validate that the Django application is correctly deployed in the Kubernetes cluster and successfully communicating with the MySQL database.

### 1. Project Infrastructure Setup
All Kubernetes manifests are located in the .infrastructure directory. Before proceeding, ensure you are in the project root and apply the configurations:

Navigate to the infrastructure folder if needed

`cd .infrastructure`

### 2. Verify that the StatefulSet has successfully created all 3 replicas and that the Headless Service is active:

Check MySQL Pods (Expected: mysql-0, mysql-1, mysql-2)

`kubectl get pods -n mysql`

Check Headless Service

`kubectl get svc -n mysql`

Check App Pods

`kubectl get pods -n todoapp`

### 3. Database Initialization:
1.Launch the client:

`kubectl run mysql-client --image=mysql:8.0 -it -n mysql -- sh`

2.Inside the client pod, try connecting to mysql-0:

`mysql -h mysql-0.mysql.mysql.svc.cluster.local -u root -p21011994`

3.Check DB Initialization:

`SHOW DATABASES;`

4.Use databases:
`USE tododb;`

5.Show created tables:

`SHOW TABLES;`


