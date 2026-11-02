# Validation Instructions

## Prerequisites

- Docker
- [kind](https://kind.sigs.k8s.io/)
- kubectl

## 1. Create the cluster

```bash
kind create cluster --config cluster.yml
```

## 2. Deploy all resources

```bash
bash bootstrap.sh
```

This applies, in order: the `todoapp` and `mysql` namespaces, the PV/PVC, the MySQL ConfigMap/Secret/headless Service, the MySQL `StatefulSet`, and the application's ConfigMap/Secret/Services/HPA/`Deployment`.

## 3. Verify the MySQL StatefulSet

```bash
kubectl get statefulset -n mysql
kubectl get pods -n mysql
```

Expect 3 running pods: `mysql-0`, `mysql-1`, `mysql-2`.

Check that `mysql-0` was initialized from `init.sql` (table `counter` created in `app_db`):

```bash
kubectl exec -n mysql -it mysql-0 -- mysql -uapp_user -p app_db -e "SHOW TABLES;"
```
(enter the password stored in the `mysql-secrets` Secret, `MYSQL_PASSWORD` key, when prompted)

## 4. Verify the application Deployment

```bash
kubectl get pods -n todoapp
kubectl logs -n todoapp deployment/todoapp
```

The application connects to `mysql-0` (`HOST` key in the `app-secret` Secret, namespace `todoapp`) using the credentials from the same Secret (`NAME`, `USER`, `PASSWORD`). Logs should show no database connection errors.

## 5. Access the application

The app is exposed via `NodePort` on port `30007` (mapped in `cluster.yml`).

```
http://localhost:30007/
```

Check the landing page, the `/api/` endpoint, and that login/registration/to-do CRUD operations work and persist (data is stored in MySQL, not SQLite).

## 6. Check secrets are not applied in plaintext

```bash
kubectl get secret app-secret -n todoapp -o yaml
kubectl get secret mysql-secrets -n mysql -o yaml
```

Values under `data:` should be base64-encoded; decode with:

```bash
echo "<value>" | base64 -d
```

## Teardown

```bash
kind delete cluster
```
