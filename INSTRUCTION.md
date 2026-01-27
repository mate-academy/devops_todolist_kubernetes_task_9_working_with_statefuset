# Validation Guide

This file explains how to validate the Kubernetes resources created for the task.

## 1 Create the cluster

```bash
kind create cluster --config cluster.yml
```

Verify nodes:

```bash
kubectl get nodes
```

## 2 Deploy all resources

```bash
./bootstrap.sh
```

## 3 Check namespaces

```bash
kubectl get ns
```

## 4 Check MySQL resources

```bash
kubectl get pods -n mysql
kubectl get svc -n mysql
kubectl get statefulset -n mysql
```

Wait until `mysql-0`, `mysql-1`, `mysql-2` are `Running` and `Ready`.

Describe the StatefulSet for probes, PVC, and images:

```bash
kubectl describe statefulset mysql -n mysql
```

## 5 Check MySQL init.sql execution

Exec into `mysql-0` and list databases (should include `tododb`):

```bash
kubectl exec -n mysql -it mysql-0 -- sh
```

Then run inside the pod:

```bash
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES;"
```

If the password prompt appears, use the value from `.infrastructure/mysql/secret.yml`.

## 6 Check app resources

```bash
kubectl get pods -n todoapp
kubectl describe deployment todoapp -n todoapp
```

Verify the pod has env vars from `app-db-secret`:

```bash
kubectl exec -n todoapp -it deploy/todoapp -- sh
```

Then run inside the pod:

```bash
env | grep -E "NAME|USER|PASSWORD|HOST"
```

## 7 Validate the app endpoints

Port-forward the service (NodePort also works if configured):

```bash
kubectl port-forward -n todoapp svc/todoapp 8080:8080
```

Open in browser or curl:

```bash
curl http://localhost:8080/api/health
curl http://localhost:8080/api/ready
```
