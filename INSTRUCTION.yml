# Validation Instructions

## Prerequisites
- Docker installed and running
- kind installed
- kubectl installed

## Deployment

Run the bootstrap script to deploy all resources:

```bash
./bootstrap.sh
```

## Validation Steps

### 1. Verify Kind Cluster

Check that the Kind cluster was created successfully:

```bash
kind get clusters
```

Verify all nodes are ready:

```bash
kubectl get nodes
```

### 2. Verify MySQL StatefulSet

Check that all 3 MySQL pods are running:

```bash
kubectl get pods -n mysql
```

You should see `mysql-0`, `mysql-1`, and `mysql-2` pods in Running state.

### 3. Verify MySQL Database
Connect to mysql-0 and check the database:

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -uuser -puserpass -e "SHOW DATABASES;"
```
You should see `todoapp-db` in the list.

### 4. Verify Persistent Volumes
Check that PersistentVolumeClaims were created for each MySQL pod:

```bash
kubectl get pvc -n mysql
```

### 5. Access the Application
Port-forward to access TodoApp locally:

```bash
kubectl port-forward -n todoapp <pod-name> 8080:8080
```

Open http://localhost:8080 in your browser.

## Cleanup

To delete the entire cluster:

```bash
kind delete cluster
```
