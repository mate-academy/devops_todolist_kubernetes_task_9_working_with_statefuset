# Validation Instructions

## Prerequisites

- [Docker](https://www.docker.com/)
- [kind](https://kind.sigs.k8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Deploy the cluster

`bootstrap.sh` applies only the manifests added or updated in this task:

- `.infrastructure/statefulSet.yml` — MySQL namespace, secrets, init ConfigMap, headless Service, StatefulSet
- `.infrastructure/db-secret.yml` — `todoapp` namespace, `app-secret`, `app-config`, PV/PVC, and database connection Secret
- `.infrastructure/deployment.yml` — updated ToDo application Deployment

The bootstrap script creates a local `kind` cluster inline (no external `cluster.yml` required).

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## Validate MySQL StatefulSet

1. Check that the `mysql` namespace exists and contains 3 MySQL pods:

```bash
kubectl get namespace mysql
kubectl get statefulset -n mysql
kubectl get pods -n mysql
```

Expected result: StatefulSet `mysql` with 3/3 ready replicas (`mysql-0`, `mysql-1`, `mysql-2`).

2. Check that the headless Service is created:

```bash
kubectl get svc -n mysql
```

Expected result: Service `mysql` with `CLUSTER-IP` equal to `None`.

3. Check that MySQL pods have probes and resource limits:

```bash
kubectl describe statefulset mysql -n mysql
```

4. Check that secrets and init ConfigMap are applied:

```bash
kubectl get secret mysql-secret -n mysql
kubectl get configmap mysql-init -n mysql
```

5. Verify that MySQL is initialized with the `tododb` database:

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u todo_user -ptodo_password -e "SHOW DATABASES;"
```

Expected result: database `tododb` is present in the output.

6. Check persistent storage:

```bash
kubectl get pvc -n mysql
```

Expected result: 3 PVCs created from `volumeClaimTemplates`.

## Validate ToDo application

1. Check that the application reads database connection settings from Secret:

```bash
kubectl get secret db-secret -n todoapp
kubectl describe deployment todoapp -n todoapp | grep -A 20 "Environment:"
```

Expected result: environment variables `NAME`, `USER`, `PASSWORD`, and `HOST` are loaded from `db-secret`. `HOST` should point to `mysql-0.mysql.mysql.svc.cluster.local`.

2. Check that application pods are running:

```bash
kubectl get pods -n todoapp
kubectl wait --for=condition=ready pod -l app=todoapp -n todoapp --timeout=300s
```

3. Open the application in a browser:

```bash
kubectl get svc todoapp-nodeport -n todoapp
```

Application should be available at `http://localhost:30007`.

4. Check health endpoints:

```bash
kubectl port-forward svc/todoapp-service 8080:80 -n todoapp
curl http://localhost:8080/api/health
curl http://localhost:8080/api/ready
```

## Cleanup

```bash
kind delete cluster
```
