## Validation & Verification Guide
This guide provides step-by-step instructions to validate that the Django application is correctly deployed in the Kubernetes cluster and successfully communicating with the MySQL database.

### 1. Quick Start: Automated Deployment:
To deploy the entire infrastructure (Namespace, Storage, Database, and Application) in the correct order, use the provided automation script:

1. Make the script executable:
`chmod +x bootstrap.sh`
2. Run the deployment:
`./bootstrap.sh`


### 2. Project Infrastructure Setup
All Kubernetes manifests are located in the .infrastructure directory. Before proceeding, ensure you are in the project root and apply the configurations:

Navigate to the infrastructure folder if needed

`cd .infrastructure`

### 3. Verify that the StatefulSet has successfully created all 3 replicas and that the Headless Service is active:

Check MySQL Pods (Expected: mysql-0, mysql-1, mysql-2)

`kubectl get pods -n mysql`

Check Headless Service

`kubectl get svc -n mysql`

Check configuration Storage Objects:

`kubectl get secret -n mysql`

`kubectl get cm -n mysql`

Check App Pods

`kubectl get pods -n todoapp`

### 4. Infrastructure Validation
After the deployment is complete, verify that the StatefulSet and Service meet all technical requirements using the following commands:

1. Verify StatefulSet Configuration
`kubectl get statefulset mysql -n mysql -o yaml`

2. Verify Headless Service:
`kubectl describe svc mysql -n mysql`

3. Verify Init Script (ConfigMap Mount)
Check if the init.sql file is correctly mounted from the ConfigMap into the MySQL initialization directory:
`kubectl exec -n mysql mysql-0 -- ls /docker-entrypoint-initdb.d`

### 5. Database Credentials & Secret Validation
The application is configured to securely read database connection details from a Kubernetes Secret named app-secret. Use the following steps to verify the data integrity and its injection into the application.

1. Verify Secret Content (Base64 Decoding)
Kubernetes stores secrets in Base64 format. You can check the presence of the required keys (NAME, USER, PASSWORD, HOST) and decode them using these commands:
`kubectl get secret app-secret -n todoapp -o jsonpath='{.data}'`

2. Verify Environment Variable Injection
To confirm that the Deployment correctly mounts these secrets as environment variables inside the running container, pick one of the application pods and run:
`kubectl exec -n todoapp <pod-name> -- env | grep -E "NAME|USER|PASSWORD|HOST"`

### 6. Database Initialization:
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


