# StatefulSet

## Prerequisites
* Namespace `mysql` and `todoapp`

### Step 1: Apply all manifests:

```bash
# Create Cluster
kind create cluster --config cluster.yml

# Deploy Service
kubectl apply -f .infrastructure/services.yml

# Deploy Secrets
kubectl apply -f .infrastructure/secret.yml

# Deploy ConfigMap
kubectl apply -f .infrastructure/configMap.yml

# Deploy ConfigMap for db
kubectl apply -f .infrastructure/configMap-db.yml

# Deploy Secrets for db
kubectl apply -f .infrastructure/secret-db.yml

# Deploy StatefulSet
kubectl apply -f .infrastructure/statefulSet.yml

# Deploy Persistent Volume
kubectl apply -f .infrastructure/pv.yml

# Deploy Persistent Volume Claim
kubectl apply -f .infrastructure/pvc.yml

# Deploy todoapp application
kubectl apply -f .infrastructure/deployment.yml
```

### Step 2: Confirm all resources are running:

```bash
# Check ConfigMap
kubectl get configmap -n mysql

# Check Secrets
kubectl get secrets -n mysql
kubectl get secrets -n todoapp

# Check Deployment
kubectl get deployment -n todoapp
```

### Step 3: Verify and validate the deployment works:

```bash
# Get pods for todoapp application
kubectl get pods -n todoapp

# Get pods for mysql
kubectl get pods -n mysql
```

```bash
# Validate deployment (application) is running
kubectl port-forward deployment/todoapp 8083:8080 -n todoapp
```

To make sure todoapp is working use this link: http://localhost:8083/.

```bash
# Connect to the termilal for the pod of our application (todpapp)
kubectl exec <pod-name> -n todoapp -it -- sh
```

Execute commands to make sure that ConfigMap and Secret data are mounted as files:

For `todoapp` application we have:
- secrets as: SECRET_KEY, NAME, USER, PASSWORD, HOST
- configMap as: PYTHONUNBUFFERED

You can see it on the screenshot:

```bash
# ls
Dockerfile  accounts  api  configs  data  db.sqlite3  lists  manage.py  probes  requirements.txt  secrets  todolist
# cd secrets
# ls
HOST  NAME  PASSWORD  SECRET_KEY  USER
# cat NAME
app_db# cat HOST
mysql-0.mysql.mysql.svc.cluster.local# cd ..
# cd configs
# ls
PYTHONUNBUFFERED
# cat PYTHONUNBUFFERED
1# cd ..
# exit
```

```bash
# Connect to the termilal for the pod of our mysql
kubectl exec <pod-name> -n mysql -it -- sh
```

For `mysql` server we have:

```bash
sh-5.1# mysql -h mysql-0.mysql -u root -p1234 -e "SHOW DATABASES;"
mysql: [Warning] Using a password on the command line interface can be insecure.
+--------------------+
| Database           |
+--------------------+
| app_db             |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
sh-5.1# exit
exit
```

Or we can validate programmatically for `todoapp` application as:

```bash
# Get the pod name programmatically
POD_NAME=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')

# Verify ConfigMap mount
kubectl exec -n todoapp $POD_NAME -- cat /app/configs/PYTHONUNBUFFERED

# Verify Secret mount
kubectl exec -n todoapp $POD_NAME -- cat /app/secrets/SECRET_KEY

# Verify Data volume mount
kubectl exec -n todoapp $POD_NAME -- df -h /app/data
```