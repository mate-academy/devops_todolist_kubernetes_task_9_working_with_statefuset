# Validation Instructions

## Prerequisites

- `kubectl` configured and connected to your cluster
- All manifest files present in the `.infrastructure` directory

---

## 1. Deploy all resources

```bash
./bootstrap.sh
```

---

## 2. Validate Namespaces

```bash
kubectl get namespaces
```

**Expected:** Both `mysql` and `todoapp` namespaces are listed.

---

## 3. Validate MySQL StatefulSet

```bash
kubectl get statefulset -n mysql
```

**Expected:** `mysql` StatefulSet with `3/3` ready replicas.

```bash
kubectl get pods -n mysql
```

**Expected:** 3 pods (`mysql-0`, `mysql-1`, `mysql-2`) all in `Running` state.

---

## 4. Validate MySQL Secrets

```bash
kubectl get secret mysql-secrets -n mysql
```

**Expected:** Secret exists with 3 keys (`MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`).

---

## 5. Validate Headless Service

```bash
kubectl get svc -n mysql
```

**Expected:** `mysql` service with `ClusterIP` of `None`.

---

## 6. Validate MySQL Pod Probes

```bash
kubectl describe pod mysql-0 -n mysql
```

**Expected:** Both probes are configured and passing (no failure events).

---

## 7. Validate MySQL Persistent Volumes

```bash
kubectl get pvc -n mysql
```

**Expected:** 3 PVCs (`data-mysql-0`, `data-mysql-1`, `data-mysql-2`) all in `Bound` state.

---

## 8. Validate MySQL init.sql was applied

```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p1234 -e "SHOW DATABASES;"
```

**Expected:** Your database created by `init.sql` is listed.

---

## 9. Validate todoapp Secret

```bash
kubectl get secret app-secret -n todoapp
```

**Expected:** Secret exists with keys `SECRET_KEY`, `NAME`, `USER`, `PASSWORD`, `HOST`.

Decode and verify HOST:

```bash
kubectl get secret app-secret -n todoapp -o jsonpath='{.data.HOST}' | base64 -d
```

**Expected:** `mysql-0.mysql.mysql.svc.cluster.local`

---

## 10. Validate todoapp Deployment

```bash
kubectl get deployment -n todoapp
```

**Expected:** `todoapp` deployment with desired replicas all ready.

```bash
kubectl get pods -n todoapp
```

**Expected:** All pods in `Running` state.
