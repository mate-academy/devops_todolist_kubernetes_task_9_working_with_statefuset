1. Check Namespaces and Resources
Verify that the components are deployed in their proper isolated namespaces:

Bash
# Check MySQL StatefulSet in the 'mysql' namespace
kubectl get pods,sts,svc,pvc -n mysql

# Check Django ToDo app in the 'todoapp' namespace
kubectl get pods,deploy,svc -n todoapp
2. Validate MySQL StatefulSet Requirements
Replicas Count: Ensure that 3 replicas (mysql-0, mysql-1, mysql-2) are deployed.

Headless Service: Verify that service/mysql has CLUSTER-IP: None (Headless).

Probes & Resources: Inspect one of the MySQL pods to verify that Requests/Limits and Liveness/Readiness probes are configured correctly:

Bash
kubectl describe pod mysql-0 -n mysql
3. Verify Database Initialization
Check if the init.sql script was successfully propagated via the ConfigMap volume and executed on database startup:

Bash
kubectl logs mysql-0 -n mysql | grep "init.sql"
4. Validate Application Connectivity
The ToDo application is explicitly configured to connect to the 0-indexed database pod (mysql-0).

Verify that the environment variables (NAME, USER, PASSWORD, HOST) are populated from the Secrets:

Bash
kubectl describe deploy todoapp -n todoapp
Check the application logs to ensure it successfully established a connection to mysql-0.mysql.mysql.svc.cluster.local and didn't crash:

Bash
kubectl logs deployment/todoapp -n todoapp
5. Access the Interactive UI
To manually check the web interface, forward the application port to your local machine:

Bash
kubectl port-forward deployment/todoapp 8080:8080 -n todoapp