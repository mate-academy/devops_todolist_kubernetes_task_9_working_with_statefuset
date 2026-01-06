### 1. Create the `kind` Cluster

```bash
kind create cluster --config cluster.yml
```

This will set up a cluster with control-plane and worker nodes as defined in `cluster.yml`

### 2. Deploy the Application and Database

Run the `bootstrap.sh` script to deploy all the necessary Kubernetes resources into `todoapp` namespace

```bash
bootstrap.sh
```

The script will:
1. Create the `todoapp` namespace
2. Deploy the MySQL database as a StatefulSet with 3 replicas
3. Wait for the MySQL pods to become ready
4. Deploy the Django ToDo application
5. Expose the application via a NodePort service

### 3. Validate the Deployment
#### Check Pods
Verify that the MySQL and ToDo application pods are running

```bash
kubectl get pods -n todoapp
```

#### Check Services
Verify that the services are created.

```bash
kubectl get svc -n todoapp
```

#### Check Persistent Volumes
The StatefulSet creates PersistentVolumeClaims (PVCs) automatically. Check their status.

```bash
kubectl get pvc -n todoapp
```

### 4. Access the Application

The application is exposed on `localhost` at port `30007`

Open your web browser and navigate to [http://localhost:30007](http://localhost:30007)