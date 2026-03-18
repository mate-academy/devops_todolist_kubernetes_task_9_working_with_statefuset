## Kubernetes task 9 — StatefulSet (MySQL)

### 1) Create kind cluster

```bash
kind create cluster --config cluster.yml
```

### 2) Deploy resources

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 3) Validate MySQL StatefulSet

```bash
kubectl -n mysql get pods -o wide
kubectl -n mysql get svc mysql-headless
kubectl -n mysql describe statefulset mysql
```

Check that pods are created with stable names:
- `mysql-0`, `mysql-1`, `mysql-2`

Show logs for `mysql-0`:

```bash
kubectl -n mysql logs pod/mysql-0 --tail=100
```

### 4) Validate ToDo app connectivity to mysql-0

```bash
kubectl -n todoapp get pods
kubectl -n todoapp describe deploy todoapp
```

The app reads DB connection info from Secret `todoapp-db`:
- `NAME`, `USER`, `PASSWORD`, `HOST`

Confirm env is present:

```bash
kubectl -n todoapp exec -it deploy/todoapp -- printenv | grep -E '^(NAME|USER|PASSWORD|HOST|PORT)='
```

### 5) Validate application is running

```bash
kubectl -n todoapp port-forward svc/todoapp-service 8080:80
```

In another terminal:

```bash
curl -i http://localhost:8080/api/ready
curl -i http://localhost:8080/api/health
```

