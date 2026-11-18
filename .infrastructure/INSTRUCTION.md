# INSTRUCTION

How to deploy and validate the MySQL StatefulSet and the Django ToDo app in a `kind` cluster.

## Requirements

- Docker
- kind
- kubectl

## 1. Deploy

Run from the root of the repository:

```bash
./bootstrap.sh
```

The script creates the cluster and all resources. It waits until MySQL and the app are ready.
It can take a few minutes, because the 3 MySQL pods start one after another.

## 2. Validate MySQL

**StatefulSet is in the `mysql` namespace and has 3 replicas:**

```bash
kubectl get statefulset,pods -n mysql
```

Expected: `3/3` ready, pods `mysql-0`, `mysql-1`, `mysql-2` are `Running`.

**Headless Service:**

```bash
kubectl get svc -n mysql
```

Expected: `CLUSTER-IP` is `None`.

**volumeClaimTemplates (one volume per pod):**

```bash
kubectl get pvc -n mysql
```

Expected: 3 PVCs with status `Bound`.

**Probes, requests and limits:**

```bash
kubectl describe pod mysql-0 -n mysql
```

Expected: you can see `Liveness`, `Readiness`, `Limits` and `Requests` (CPU and Memory).

**Data from the Secret:**

```bash
kubectl exec -n mysql mysql-0 -- env | grep MYSQL_USER
```

Expected: the user name is shown.

**`init.sql` is mounted and was executed:**

```bash
kubectl exec -n mysql mysql-0 -- ls /docker-entrypoint-initdb.d
kubectl exec -n mysql mysql-0 -- sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE app_db; SHOW TABLES;"'
```

Expected: the file `init.sql` is in the folder, and the table `counter` exists.

## 3. Validate the application

**Pods:**

```bash
kubectl get pods -n todoapp
```

Expected: the app pods are `Running` (the HPA can start up to 2 pods).

**Open the app:** go to http://localhost:30007 and create a few tasks.

If the page does not open, use port forwarding:

```bash
kubectl port-forward -n todoapp svc/todoapp-service 8080:80
```

Then open http://localhost:8080.

**The app writes to `mysql-0`:**

```bash
kubectl exec -n mysql mysql-0 -- sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE app_db; SHOW TABLES;"'
```

Expected: besides `counter`, there are Django tables (`django_*`).

**Control check:** the 3 MySQL pods are independent, they do not replicate data.
The app uses only `mysql-0`, so `mysql-1` has no Django tables:

```bash
kubectl exec -n mysql mysql-1 -- sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "USE app_db; SHOW TABLES;"'
```

Expected: no `django_*` tables.

## 4. Database connection settings

The app reads `NAME`, `USER`, `PASSWORD` and `HOST` from the Secret `app-secret` (namespace `todoapp`).
`HOST` points to the first database pod: `mysql-0.mysql.mysql.svc.cluster.local`.

```bash
kubectl describe secret app-secret -n todoapp
```

Expected: the keys `NAME`, `USER`, `PASSWORD`, `HOST` are listed (values are hidden).

## 5. Clean up

```bash
kind delete cluster --name statefusetcluster
```