# Instructions for verifying the correctness of the changes

## 1. Start the deployment

Run the bootstrap script from the root directory of the project:

```bash
bash bootstrap.sh
```

## 2. Check the namespaces

```bash
kubectl get namespaces
```

The following namespaces must exist:

```text
mysql
todoapp
```

## 3. Check the StatefulSet

```bash
kubectl get statefulset -n mysql
```

The StatefulSet must have three ready replicas.

Check the MySQL pods:

```bash
kubectl get pods -n mysql
```

The following three pods must be in the `Running` state and have `1/1` containers ready:

```text
mysql-0
mysql-1
mysql-2
```

## 4. Check the headless Service

```bash
kubectl get service mysql -n mysql
```

The `CLUSTER-IP` column for the `mysql` Service must contain:

```text
None
```

## 5. Check the PVCs created by volumeClaimTemplates

```bash
kubectl get pvc -n mysql
```

Three PVCs should be created automatically:

```text
data-mysql-0
data-mysql-1
data-mysql-2
```

All PVCs must have the `Bound` status.

## 6. Check the Deployment

```bash
kubectl get deployment -n todoapp
```

Check the application pods:

```bash
kubectl get pods -n todoapp
```

The application pod must be in the `Running` state and have `1/1` containers ready.

## 7. Open the application

Forward the local port to the application Deployment:

```bash
kubectl port-forward deployment/todoapp 8080:8080 -n todoapp
```

Open the following address in a browser:

```text
http://localhost:8080
```

Keep the terminal with the `port-forward` command open while using the application.

## 8. Check the database connection and data persistence

Create a new task in the ToDo application and make sure that it appears on the page.

Restart the MySQL StatefulSet:

```bash
kubectl rollout restart statefulset/mysql -n mysql
```

Check the restart status:

```bash
kubectl rollout status statefulset/mysql -n mysql
```

After the restart is completed, verify that all MySQL pods are running again:

```bash
kubectl get pods -n mysql
```

The pods `mysql-0`, `mysql-1`, and `mysql-2` must be in the `Running` state and have `1/1` containers ready.

Refresh the application page and verify that the previously created task is still present.

If the task remains after the StatefulSet restart, the application is connected to MySQL successfully and the database data is stored persistently.