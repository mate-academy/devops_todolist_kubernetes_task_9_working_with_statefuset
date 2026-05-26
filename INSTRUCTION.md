# Instruction

## Deploy

```bash
kind create cluster --config cluster.yml
bash bootstrap.sh
```

## Validate

### 1. Check MySQL StatefulSet
```bash
kubectl get statefulset -n mysql
kubectl get pods -n mysql
```
Expected: 3 pods running (mysql-0, mysql-1, mysql-2)

### 2. Check MySQL Secret
```bash
kubectl get secret mysql-secret -n mysql
```

### 3. Check PVC created for each pod
```bash
kubectl get pvc -n mysql
```
Expected: 3 PVCs (mysql-data-mysql-0, mysql-data-mysql-1, mysql-data-mysql-2)

### 4. Check headless Service
```bash
kubectl get svc -n mysql
```
Expected: mysql service with ClusterIP None

### 5. Check app is running
```bash
kubectl get pods -n todoapp
```

### 6. Check app connects to MySQL
```bash
kubectl logs -n todoapp deployment/todoapp
```
Expected: no database connection errors

### 7. Check app is accessible
```bash
kubectl get svc -n todoapp
```
Open the NodePort URL in browser and verify the app works.
