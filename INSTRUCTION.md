# Validation Instructions

This document provides step-by-step instructions to validate the Kubernetes StatefulSet deployment for the Django ToDo application with MySQL database.

## Prerequisites

1. **Kind cluster** - Ensure you have `kind` installed
2. **kubectl** - Kubernetes command-line tool
3. **Docker** - For container runtime

## Deployment and Validation Steps

### 1. Create Kind Cluster

```bash
kind create cluster --config cluster.yml --name todoapp-cluster
```

**Validation:**
```bash
kubectl cluster-info --context kind-todoapp-cluster
kubectl get nodes
```
Expected: 1 control-plane node and 2 worker nodes should be running.

### 2. Deploy All Resources

Run the bootstrap script to deploy all components:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 3. Validate Namespaces

```bash
kubectl get namespaces
```
**Expected output:**
- `todoapp` namespace should exist
- `mysql` namespace should exist

### 4. Validate MySQL StatefulSet

#### Check StatefulSet Status
```bash
kubectl get statefulset -n mysql
kubectl describe statefulset mysql -n mysql
```
**Expected:**
- StatefulSet `mysql` should exist in `mysql` namespace
- Replicas: 3/3 ready
- All pods should be in Running state

#### Check MySQL Pods
```bash
kubectl get pods -n mysql
```
**Expected:**
- 3 pods: `mysql-0`, `mysql-1`, `mysql-2`
- All pods should be in Running/Ready state

#### Check MySQL Service (Headless)
```bash
kubectl get svc -n mysql
kubectl describe svc mysql -n mysql
```
**Expected:**
- Service `mysql` should exist
- ClusterIP should be `None` (headless service)
- Port 3306 should be exposed

#### Check Persistent Volume Claims
```bash
kubectl get pvc -n mysql
```
**Expected:**
- 3 PVCs should exist: `mysql-mysql-0`, `mysql-mysql-1`, `mysql-mysql-2`
- All should be in `Bound` status with 2Gi storage

### 5. Validate MySQL Configuration

#### Check ConfigMap
```bash
kubectl get configmap mysql-config -n mysql -o yaml
```
**Expected:**
- ConfigMap should contain `init.sql` with database initialization script

#### Check Secret
```bash
kubectl get secret mysql-secret -n mysql
kubectl describe secret mysql-secret -n mysql
```
**Expected:**
- Secret should contain `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`

#### Test Database Connection
```bash
# Connect to mysql-0 pod
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p
# Enter password: 1234
```
**In MySQL shell, verify:**
```sql
SHOW DATABASES;  -- Should show 'tododb' database
USE tododb;
SHOW TABLES;     -- Should show initialized tables
SELECT User FROM mysql.user WHERE User = 'app_user';  -- Should show app_user
```

### 6. Validate TodoApp Deployment

#### Check Deployment Status
```bash
kubectl get deployment -n todoapp
kubectl describe deployment todoapp -n todoapp
```
**Expected:**
- Deployment `todoapp` should exist in `todoapp` namespace
- All replicas should be ready

#### Check TodoApp Pods
```bash
kubectl get pods -n todoapp
```
**Expected:**
- TodoApp pods should be in Running/Ready state

#### Check TodoApp Configuration
```bash
kubectl get secret app-secret -n todoapp
kubectl get configmap app-config -n todoapp
```
**Expected:**
- Secret should contain database connection details (NAME, USER, PASSWORD, HOST, PORT)
- HOST should point to `mysql-0.mysql.mysql.svc.cluster.local`

### 7. Validate Application Connectivity

#### Test Database Connection from TodoApp
```bash
# Get a todoapp pod name
TODOAPP_POD=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')

# Check environment variables
kubectl exec -n todoapp $TODOAPP_POD -- env | grep DB_
```
**Expected:**
- DB_HOST should be `mysql-0.mysql.mysql.svc.cluster.local`
- DB_PORT should be `3306`
- DB_NAME should be `tododb`
- DB_USER should be `app_user`

#### Test Network Connectivity
```bash
# Test if todoapp can reach mysql-0
kubectl exec -n todoapp $TODOAPP_POD -- nslookup mysql-0.mysql.mysql.svc.cluster.local
kubectl exec -n todoapp $TODOAPP_POD -- nc -zv mysql-0.mysql.mysql.svc.cluster.local 3306
```
**Expected:**
- DNS resolution should work
- Port 3306 should be reachable

### 8. Validate Application Functionality

#### Check Application Health
```bash
# Forward port to access the application
kubectl port-forward -n todoapp svc/todoapp-service 8080:8080
```

In another terminal:
```bash
# Test health endpoints
curl http://localhost:8080/api/health
curl http://localhost:8080/api/ready
```
**Expected:**
- Both endpoints should return successful responses

#### Access Application UI
Open browser and navigate to `http://localhost:8080`
**Expected:**
- TodoApp landing page should load
- You should be able to register/login
- Database operations should work (create/read todos)

### 9. Validate Resource Constraints and Probes

#### Check Resource Limits
```bash
kubectl describe pod -n mysql -l app=mysql
kubectl describe pod -n todoapp -l app=todoapp
```
**Expected:**
- MySQL pods: CPU 500m, Memory 1Gi (requests and limits)
- TodoApp pods: CPU 150m, Memory 256Mi (requests and limits)

#### Check Probes
```bash
kubectl describe pod -n mysql -l app=mysql | grep -A5 "Liveness\|Readiness"
kubectl describe pod -n todoapp -l app=todoapp | grep -A5 "Liveness\|Readiness"
```
**Expected:**
- MySQL: liveness and readiness probes using `mysqladmin ping`
- TodoApp: HTTP probes on `/api/health` and `/api/ready`

### 10. Validate StatefulSet Behavior

#### Test Pod Restart and Data Persistence
```bash
# Delete mysql-0 pod
kubectl delete pod mysql-0 -n mysql

# Wait and check if it comes back with same identity
kubectl get pods -n mysql -w
```
**Expected:**
- Pod should restart as `mysql-0` (same identity)
- Data should persist after restart

#### Test Ordered Deployment
```bash
# Scale down to 1 replica
kubectl scale statefulset mysql -n mysql --replicas=1

# Scale back up to 3
kubectl scale statefulset mysql -n mysql --replicas=3

# Watch the pods come up
kubectl get pods -n mysql -w
```
**Expected:**
- Pods should scale down in reverse order (mysql-2, mysql-1)
- Pods should scale up in order (mysql-1, then mysql-2)
