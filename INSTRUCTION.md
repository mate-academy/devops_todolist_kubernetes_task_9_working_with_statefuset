# Validation Instructions

## 1. Create the cluster

```bash
kind create cluster --config cluster.yml
```

## 2.  Check MySQL StatefulSet

```bash
kubectl get statefulset -n mysql
kubectl get pods -n mysql
```

## 3. Check Service and PVCs

```bash
kubectl get service -n mysql
kubectl get pvc -n mysql
```

## 4. Check MySQL

```bash
kubectl exec -it mysql-0 -n mysql -- mysqladmin ping
```

## 5. Check application

```bash
kubectl get deployment,pods -n mysql
```
