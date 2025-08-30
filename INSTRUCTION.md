## How to Validate

### 1. Check Application and Database Pods

```sh
kubectl get pods -n todoapp
kubectl get pods -n mysql
```

### 2. Check Secrets Are Set

```sh
kubectl get secret mysql-secret.yml -n todoapp -o yaml
```

### 3. Check Environment Variables in App Pod

```sh
kubectl exec -it <app-pod-name> -n todoapp -- env | grep DB_
```

### 4. Check App Connectivity

Port-forward and test:

```sh
kubectl port-forward deployment/todoapp 8080:8080 -n todoapp
curl http://localhost:8080/
```

### 5. Check MySQL Pod

```sh
kubectl exec -it mysql-0 -n mysql -- mysql -u<your_db_user> -p<your_db_password> -e "SHOW DATABASES;"