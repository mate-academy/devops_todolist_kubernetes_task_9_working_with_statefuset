## Instruction for validation the deployment of the ToDo application
Follow these steps to verify that all resources in the cluster are working properly.
---
### 1. Check Pod status(Apps running)
Make sure that the pod with the application has started successfully and is in the Running status:
```bash
kubectl get pods
```

2. Verifying the ConfigMap mount
```bash
kubectl exec -it <pod-name> -- ls -la /app/configs
```
 Check that the contents of the configuration files:
 ```bash
kubectl exec -it <pod-name> -- cat /app/configs/your-config-key
```
Check that the file-system in write-protected (Read-only):
```bash
kubectl exec -it <pod-name> -- touch /app/configs/test.txt
```
3. Check the mounting of the secret:
1. View the list of files in the secrets directory:
```bash
kubectl exec -it <pod-name> -- ls /app/secrets/test.txt
```
2. Check that the secrets are mounted correctly:
```bash
kubectl exec -it <pod-name> -- cat /app/secrets/your-secret-key
```
3. Check for head-only access:
```bash
kubectl exec -it <pod-name> -- touch /app/secrets/test.txt
```
4. Verification of MySQL StatefulSet

Follow these steps to validate that the MySQL StatefulSet is running correctly and maintaining state.

### Step 1: Check Pod Status and Ordering
Verify that all 3 replicas are running. In a StatefulSet, pods are created sequentially (`mysql-0`, then `mysql-1`, then `mysql-2`):
```bash
kubectl get pods -n mysql -l app=mysql
```
5. Verify Headless Service and DNS Resolution

Check that the Headless Service is created and successfully managing the endpoints:
```bash
kubectl get svc mysql-headless -n mysql
kubectl get endpoints mysql-headless -n mysql
```

6. Verify Persistent Volumes (State Preservation)

Verify that volumeClaimTemplates dynamically provisioned 3 distinct Persistent Volume Claims (PVCs):
```bash
kubectl get pvc -n mysql
```
7. Verify Database Initialization (init.sql)

To ensure that the init.sql script from your ConfigMap was mounted and executed successfully inside the 0-indexed pod, run the following command to list the tables:
```bash
# Exec into the master pod and run a MySQL command
# (Replace 'root' and 'your_password' if you used different values in your secret)
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p -e "SHOW TABLES;"
```
