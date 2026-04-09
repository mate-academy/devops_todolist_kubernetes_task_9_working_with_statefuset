# Deployment Instructions

## 1. Deploy all resources

Run the bootstrap script:

```bash
bash bootstrap.sh
```

## 2. Verify MySQL StatefulSet

Check pods in mysql namespace:

```bash
kubectl get pods -n mysql
```

_**Expected:**_

mysql-0 \
mysql-1 \
mysql-2

Check service:
```bash
kubectl get svc -n mysql
```

_**Expected:**_

mysql (ClusterIP: None)

## 3. Verify todoapp Deployment

Check pods:
```bash
kubectl get pods -n todoapp
```

Check services:
```bash
kubectl get svc -n todoapp
```

## 4. Verify application connectivity

Forward port:

```bash
kubectl -n todoapp port-forward svc/todoapp-service 8080:80
```

Open in browser:
http://localhost:8080

## 5. Verify environment variables inside pod
```bash
kubectl exec -it <todoapp-pod-name> -n todoapp -- printenv | grep DB
```

_**Expected variables:**_

DB_NAME \
DB_USER \
DB_PASSWORD \
DB_HOST 

## 6. Verify MySQL initialization
```bash
kubectl logs mysql-0 -n mysql
```
