# Validation Instructions

## 1. Deploy everything

```bash
./bootstrap.sh
```

## 2. Check cluster and namespaces

```bash
kind get clusters
kubectl get ns
```

Expected:
- kind cluster `todoapp` exists
- namespaces `todoapp` and `mysql` exist

## 3. Validate MySQL StatefulSet

```bash
kubectl get statefulset -n mysql
kubectl get pods -n mysql -o wide
kubectl get svc -n mysql
kubectl get pvc -n mysql
```

Expected:
- StatefulSet `mysql` has `3/3` ready replicas
- pods `mysql-0`, `mysql-1`, `mysql-2` are Running
- headless Service `mysql` has `CLUSTER-IP` = `None`
- PVCs created from `volumeClaimTemplates`

## 4. Validate MySQL initialization from init.sql

```bash
kubectl exec -n mysql mysql-0 -- mysql -uroot -ppassword -e "USE tododb; SHOW TABLES LIKE 'bootstrap_check';"
```

Expected:
- table `bootstrap_check` exists

## 5. Validate application deployment and DB env from Secret

```bash
kubectl get deployment -n todoapp
kubectl get pods -n todoapp
kubectl describe pod -n todoapp -l app=todoapp | grep -E "DB_NAME|DB_USER|DB_HOST"
```

Expected:
- deployment `todoapp` is available
- app pod is Running
- environment variables `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST` come from secret `app-secret`

## 6. Validate service access

```bash
kubectl get svc -n todoapp
curl -I http://localhost:31007/api/health
curl -I http://localhost:31007/api/ready
```

Expected:
- NodePort service `todoapp-nodeport` exposed on port `30007` and mapped to host port `31007`
- `/api/health` returns `200`
- `/api/ready` returns `200` after warm-up interval
