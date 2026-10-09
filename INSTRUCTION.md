# Instructions for Deploying and Validating StatefulSet with MySQL Cluster

## 1. Deployment Execution
Run the bootstrap script to initialize the Kind cluster and all workloads:
```bash
./bootstrap.sh
```

---

## 2. Validation Steps

### Step 2.1: Verify MySQL StatefulSet and Pods Order
Ensure that 3 replicas are running and have stable names (`mysql-0`, `mysql-1`, `mysql-2`):
```bash
kubectl get statefulset mysql -n mysql
kubectl get pods -n mysql -w
```

### Step 2.2: Verify Headless Service DNS
Ensure the DB endpoints are successfully generated without a cluster IP:
```bash
kubectl get svc mysql-headless -n mysql
```

### Step 2.3: Verify App Pod Connection configuration
Check if the ToDo application pods correctly received environment variables pointing to `mysql-0`:
```bash
kubectl exec -it deployment/todoapp-deployment -n mateapp -- env | grep DB_
```
