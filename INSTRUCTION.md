# Django ToDo List — Task 9: StatefulSet

## Prerequisites

* Docker
* kubectl
* kind

## 1. Create the kind cluster

```bash
kind create cluster --config cluster.yml
```

Verify:

```bash
kubectl get nodes
```

## 2. Build and load the application image

```bash
docker build -t todoapp:4.0.0 ./src
kind load docker-image todoapp:4.0.0
```

## 3. Deploy the application

Make the script executable:

```bash
chmod +x bootstrap.sh
```

Run:

```bash
./bootstrap.sh
```

## 4. Verify MySQL StatefulSet

Check the StatefulSet:

```bash
kubectl get statefulset -n mysql
```

Expected:

```text
mysql   3/3
```

Check Pods:

```bash
kubectl get pods -n mysql
```

Expected Pods:

```text
mysql-0
mysql-1
mysql-2
```

All Pods must be `Running` and `Ready`.

## 5. Verify persistent storage

```bash
kubectl get pvc -n mysql
```

Three PVCs must be created and have status `Bound`.

## 6. Verify MySQL Service

```bash
kubectl get svc -n mysql
```

The `mysql` Service must be a headless Service with:

```text
CLUSTER-IP: None
```

The application connects to:

```text
mysql-0.mysql.mysql.svc.cluster.local
```

## 7. Verify MySQL configuration

Check the Secret:

```bash
kubectl get secret mysql-secret -n mysql
```

The StatefulSet must use the Secret for:

* `MYSQL_ROOT_PASSWORD`
* `MYSQL_USER`
* `MYSQL_PASSWORD`

The `init.sql` file must be mounted to:

```text
/docker-entrypoint-initdb.d
```

## 8. Verify probes and resources

```bash
kubectl describe pod mysql-0 -n mysql
```

The MySQL container must have:

* liveness probe;
* readiness probe;
* CPU requests and limits;
* memory requests and limits.

## 9. Verify Django Deployment

```bash
kubectl get deployment -n todoapp
kubectl get pods -n todoapp
```

The application Pod must be `Running` and `Ready`.

The Django Deployment must receive the following database settings from `db-secret`:

* `NAME`
* `USER`
* `PASSWORD`
* `HOST`

The `HOST` value must point to:

```text
mysql-0.mysql.mysql.svc.cluster.local
```

## 10. Verify database migrations

```bash
kubectl exec -it <TODOAPP_POD> -n todoapp -- python manage.py migrate
```

Migrations must complete successfully.

## 11. Final verification

```bash
kubectl get pods -n mysql
kubectl get pvc -n mysql
kubectl get svc -n mysql
kubectl get pods -n todoapp
```

The expected result:

* 3 MySQL StatefulSet Pods are running;
* 3 MySQL PVCs are `Bound`;
* MySQL Service is headless;
* Django Pod is running and ready;
* Django connects to `mysql-0`.
