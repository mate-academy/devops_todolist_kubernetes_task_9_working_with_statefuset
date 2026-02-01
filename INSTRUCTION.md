# Validation Instructions

Follow these steps to validate the existence and proper functioning of the cluster, nodes, StatefulSet, pods, configs, secrets, and database:

## 1. Validate the Kubernetes Cluster
Ensure the Kubernetes cluster is running:
```bash
kubectl cluster-info
```
This command should return the cluster's control plane and DNS information.

## 2. Validate the Nodes
Check if the nodes are ready:
```bash
kubectl get nodes
```
Ensure all nodes have the status `Ready`.

## 3. Validate the StatefulSet and Deployment
Check the StatefulSet in the `mysql` namespace:
```bash
kubectl get statefulsets -n mysql
```
Ensure the StatefulSet is listed and has the desired number of replicas.

Check the Deployment in the `todoapp` namespace:
```bash
kubectl get deployment -n todoapp  
```
Ensure the Deployment is listed.

## 4. Validate the Pods
Check the pods managed by the StatefulSet:
```bash
kubectl get pods -n mysql
```
Ensure all pods are in the `Running` state and have the correct names (e.g., `mysql-stateful-set-0`, `mysql-stateful-set-1`, `mysql-stateful-set-2`).

Check the pods managed by the Deployment:
```bash
kubectl get pods -n todoapp
```
Ensure all pods are in the `Running` state.

## 5. Validate ConfigMaps and Secrets
### ConfigMaps:
List the ConfigMaps in the `mysql` and `todoapp` namespaces:
```bash
kubectl get configmaps mysql-init-config -n mysql -o yaml
kubectl get configmaps app-config -n todoapp -o yaml
```
Ensure the required ConfigMaps are present.

### Secrets:
List the Secrets in the `mysql` and `todoapp` namespaces:
```bash
kubectl get secret mysql-secret -n mysql -o yaml
kubectl get secret app-secret -n todoapp -o yaml
```
Ensure the required Secrets (`MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`) in mysql namespace are present.
Ensure the required Secrets (`DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_HOST`) in todoapp namespace are present.

## 6. Validate the Database

### Connect to the Database:
Use a MySQL client to connect to the database:
```bash
kubectl exec -n mysql -it mysql-stateful-set-0 -- sh
mysql -h 127.0.0.1 -u <MYSQL_USER> -p
```
Replace `<MYSQL_USER>` with the username from the Secret. Enter the password when prompted.

### Check Initialization:
Run the following query to ensure the database is initialized:
```sql
SHOW DATABASES;
```
Ensure the expected databases are listed.

## 7. Validate Probes
Check the `livenessProbe` and `readinessProbe` configurations:
```bash
kubectl describe pods -n mysql
```
Ensure the probes are configured and functioning correctly.

## 8. Validate Resource Requests and Limits
Check the resource requests and limits for the pods:
```bash
kubectl describe pods -n mysql
```
Ensure the `requests` and `limits` for `CPU` and `Memory` are set as expected.

## 9. Validate Volume Claims
Check the PersistentVolumeClaims (PVCs):
```bash
kubectl get pvc -n mysql
```
Ensure the PVCs are bound and have the expected storage size.

## 10. Validate the Headless Service
Check the headless service for the StatefulSet:
```bash
kubectl get svc -n mysql
```
Ensure the service is listed and has the correct configuration (ClusterIP: None).
