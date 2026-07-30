### Deployment

To apply the configuration, secrets, and deploy the application, execute the following script from the root of the repository:
`bash bootstrap.sh`

Or run them by yourself

```bash
kind create cluster --config cluster.yml
```

```bash
kubectl create ns todoapp
```

```bash
kubectl create ns mysql
```

```bash
kubectl apply -f .infrastructure/service.yml
```

```bash
kubectl apply -f .infrastructure/configMapDB.yml
```

```bash
kubectl apply -f .infrastructure/secretDB.yml
```

```bash
kubectl apply -f .infrastructure/statefulSet.yml
```

```bash
kubectl apply -f .infrastructure/secret.yml
```

```bash
kubectl apply -f .infrastructure/deployment.yml
```


### Validation

1. **Check Database Status:**
Verify that the MySQL StatefulSet pods are running and ready:

```bash
kubectl get pods -n mysql
```

2. Check Application Status:
Verify that the ToDo application pods are running:

```bash
kubectl get pods -n todoapp
```

3. Verify Application Logs:
Check the logs of the application pod to ensure it successfully connected to the database:

```bash
kubectl logs -n todoapp <pod-name>
```

4. Verify Application Health and Mounted Volumes:
Execute a shell inside the pod:

```bash
kubectl exec -n todoapp -it <pod-name> -- sh
```
### Verify the application is running by checking the health endpoint:

```bash
curl http://localhost:8080/api/health
```

### Check the mounted directories and read the files:

```bash
ls -l
```

```bash
cat /app/configs/PYTHONUNBUFFERED

cat /app/secrets/SECRET_KEY
```





