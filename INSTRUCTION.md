# Validation Instructions

## Prerequisites
- `kind` installed
- `kubectl` configured
- Docker available for image building/pulling

## Steps

### 1. Create the kind cluster
```bash
kind create cluster --name todolist --config cluster.yml
```

### 2. Deploy all resources
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 3. Verify MySQL StatefulSet
```bash
# Check StatefulSet is running with 3 replicas
kubectl get statefulset mysql -n mysql

# Verify all 3 pods are ready
kubectl get pods -n mysql -l app=mysql

# Check PVCs are bound (one per replica)
kubectl get pvc -n mysql

# Verify headless service
kubectl get svc mysql-headless -n mysql
```

### 4. Verify the Deployment
```bash
# Check app is running
kubectl get pods -n todoapp -l app=todoapp

# Check env vars are loaded from secrets
kubectl exec -it deploy/todoapp -n todoapp -- env | grep DB_
```

### 5. Test connectivity
```bash
# Port-forward to the app
kubectl port-forward svc/todoapp 8080:8080 -n todoapp

# Open http://localhost:8080 in a browser
# Or test the API:
curl http://localhost:8080/api/
```

### 6. Verify DB initialization
```bash
# Check init.sql was applied
kubectl exec -it mysql-0 -n mysql -- mysql -u root -prootpass -e "SHOW DATABASES;"
```
