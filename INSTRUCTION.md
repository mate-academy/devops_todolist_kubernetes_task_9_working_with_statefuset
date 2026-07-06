# Validation Instructions

## 1. Create the cluster

Use Python 3.8+ for local application checks.

```bash
kind create cluster --config cluster.yml
```

## 2. Deploy all resources

```bash
bash bootstrap.sh
```

## 3. Validate namespaces

```bash
kubectl get namespace todoapp
kubectl get namespace mysql
```

## 4. Validate MySQL StatefulSet

Check that the StatefulSet has 3 replicas:

```bash
kubectl get statefulset mysql-statefulset -n mysql
```

Check that all MySQL pods are running:

```bash
kubectl get pods -n mysql
```

Expected pods:

```text
mysql-statefulset-0
mysql-statefulset-1
mysql-statefulset-2
```

Check probes, resources, mounted init script, and volumes:

```bash
kubectl describe pod mysql-statefulset-0 -n mysql
```

Check the headless service:

```bash
kubectl get service mysql-headless -n mysql
```

The service should have `CLUSTER-IP` set to `None`.

## 5. Validate MySQL secrets and init ConfigMap

```bash
kubectl get secret mysql-secret -n mysql
kubectl get configmap mysql-config -n mysql
```

Check that the init script is available:

```bash
kubectl describe configmap mysql-config -n mysql
```

## 6. Validate application database connection settings

Check that the application Secret contains the required database keys:

```bash
kubectl get secret app-secret -n todoapp -o jsonpath='{.data.NAME}'
kubectl get secret app-secret -n todoapp -o jsonpath='{.data.USER}'
kubectl get secret app-secret -n todoapp -o jsonpath='{.data.PASSWORD}'
kubectl get secret app-secret -n todoapp -o jsonpath='{.data.HOST}'
```

Check that the application uses the 0-indexed MySQL pod host:

```bash
kubectl get secret app-secret -n todoapp -o jsonpath='{.data.HOST}' | base64 --decode
```

Expected value:

```text
mysql-0.mysql-headless.mysql.svc.cluster.local
```

Check that the Deployment reads database values from the Secret:

```bash
kubectl describe deployment todoapp -n todoapp
```

The environment variables `NAME`, `USER`, `PASSWORD`, and `HOST` should reference `app-secret`.

## 7. Validate application deployment

```bash
kubectl get pod todoapp-pod -n todoapp
kubectl get deployment todoapp -n todoapp
kubectl get pods -n todoapp
kubectl get services -n todoapp
```

Check application logs:

```bash
kubectl logs -n todoapp deployment/todoapp
```
