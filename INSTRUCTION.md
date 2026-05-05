# Instructions to Deploy and Validate MySQL StatefulSet

## Prerequisites

Ensure you have the following tools installed:
- Docker
- kind (Kubernetes in Docker)
- kubectl

## Deploy All Resources

Run the bootstrap script to create the Kind cluster and deploy all resources:

```bash
bash bootstrap.sh
```

This script will:
1. Create a Kind cluster from `cluster.yml`
2. Deploy MySQL namespace, secret, ConfigMap, service, and StatefulSet
3. Deploy todoapp namespace, PV, PVC, ConfigMap, Secret, Deployment, Services, and HPA

## Validation Steps

### 1. Verify Kind Cluster is Running

Check that the Kind cluster was created successfully:

```bash
kind get clusters
```

Verify all nodes are ready:

```bash
kubectl get nodes
```

### 2. Verify MySQL StatefulSet

Check if the MySQL StatefulSet is deployed with 3 replicas:

```bash
kubectl get statefulset -n mysql
```

Expected output should show `mysql` with 3/3 ready replicas.

Check if all 3 MySQL pods are running:

```bash
kubectl get pods -n mysql
```

You should see `mysql-0`, `mysql-1`, and `mysql-2` pods in Running state.

### 3. Verify MySQL Secret is Being Used

Check the environment variables in one of the MySQL pods:

```bash
kubectl exec -it mysql-0 -n mysql -- env | grep MYSQL
```

You should see:
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_DATABASE=tododb`

### 4. Verify Liveness and Readiness Probes

Check the pod details to see probe configurations:

```bash
kubectl describe pod mysql-0 -n mysql | grep -A 10 "Liveness:"
kubectl describe pod mysql-0 -n mysql | grep -A 10 "Readiness:"
```

### 5. Verify Resource Requests and Limits

Check resource configurations:

```bash
kubectl describe pod mysql-0 -n mysql | grep -A 5 "Limits:"
kubectl describe pod mysql-0 -n mysql | grep -A 5 "Requests:"
```

Expected values:
- Requests: memory=512Mi, cpu=250m
- Limits: memory=1Gi, cpu=500m

### 6. Verify init.sql Initialization

Connect to the mysql-0 pod and verify the database was initialized:

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -prootpassword -e "SHOW DATABASES;"
```

You should see `tododb` in the list.

Check if the init.sql script created the tables:

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -prootpassword tododb -e "SHOW TABLES;"
```

You should see the `tasks` table.

Verify sample data was inserted:

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -prootpassword tododb -e "SELECT * FROM tasks;"
```

### 7. Verify VolumeClaimTemplates

Check that PersistentVolumeClaims were created for each pod:

```bash
kubectl get pvc -n mysql
```

You should see three PVCs:
- `mysql-data-mysql-0`
- `mysql-data-mysql-1`
- `mysql-data-mysql-2`

Check the details of a PVC:

```bash
kubectl describe pvc mysql-data-mysql-0 -n mysql
```

### 8. Verify Headless Service

Check the headless service:

```bash
kubectl get svc -n mysql
```

You should see `mysql-headless` with `ClusterIP: None`.

Test DNS resolution for individual pods:

```bash
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup mysql-0.mysql-headless.mysql.svc.cluster.local
```

### 9. Verify Database Connectivity from Application

Check the todoapp deployment has the correct environment variables:

```bash
export POD_NAME=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -n todoapp -- env | grep DB_
```

You should see:
- `DB_NAME=tododb`
- `DB_USER=todouser`
- `DB_PASSWORD=todopassword`
- `DB_HOST=mysql-0.mysql-headless.mysql.svc.cluster.local`

Test database connectivity from the todoapp pod:

```bash
kubectl exec -it $POD_NAME -n todoapp -- sh -c "apt-get update && apt-get install -y mysql-client && mysql -h mysql-0.mysql-headless.mysql.svc.cluster.local -u todouser -ptodopassword tododb -e 'SELECT 1;'"
```

### 10. Verify StatefulSet Scalability

Test that the StatefulSet maintains pod identity:

```bash
# Delete one pod
kubectl delete pod mysql-1 -n mysql

# Watch it recreate
kubectl get pods -n mysql -w
```

The pod should be recreated with the same name `mysql-1` and reattach to the same PVC.

### 11. Check StatefulSet Ordered Operations

StatefulSets create and delete pods in order. Verify by checking pod ages:

```bash
kubectl get pods -n mysql -o custom-columns=NAME:.metadata.name,AGE:.metadata.creationTimestamp
```

Pods should have been created in order: mysql-0, then mysql-1, then mysql-2.

### 12. Verify todoapp is Running

Check the todoapp deployment:

```bash
kubectl get deployment -n todoapp
kubectl get pods -n todoapp
```

Access the application through the NodePort service:

```bash
kubectl get svc -n todoapp
```

Note the NodePort and access the application at `http://localhost:<NodePort>`.

## Cleanup

To delete the Kind cluster and all resources:

```bash
kind delete cluster
```

## Troubleshooting

If MySQL pods are not starting:

```bash
kubectl logs mysql-0 -n mysql
kubectl describe pod mysql-0 -n mysql
```

If the application cannot connect to MySQL:

```bash
kubectl logs $POD_NAME -n todoapp
```

Check network connectivity:

```bash
kubectl exec -it $POD_NAME -n todoapp -- ping mysql-0.mysql-headless.mysql.svc.cluster.local
```
