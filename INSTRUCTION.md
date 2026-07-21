# Preparation

Before validation, deploy all required Kubernetes resources using the `bootstrap.sh` script.

Make the script executable:

```bash
chmod +x bootstrap.sh
```

Run the script from the root directory of the repository:

```bash
./bootstrap.sh
```

# Validation

## Verify that the application is running

Check that the application Pods are running:

```bash
kubectl get pods -n todoapp
```

Get the node IP address:

```bash
kubectl get nodes -o wide
```

Get the NodePort assigned to the application Service:

```bash
kubectl get services -n todoapp
```

Open the following URL in a browser:

```text
http://<NODE_IP>:<NODE_PORT>
```

Replace `<NODE_IP>` with the node IP address and `<NODE_PORT>` with the port exposed by the NodePort Service.

While you are on the application page, add two tasks and mark one of them as finished.

## Verify MySQL Pods

Run:

```bash
kubectl get pods -n mysql
```

You should see three Pods:

```text
NAME      READY   STATUS    RESTARTS   AGE
mysql-0   1/1     Running   0          5m51s
mysql-1   1/1     Running   0          5m40s
mysql-2   1/1     Running   0          5m27s
```

## Verify the database inside the container

Run the following command to enter the `mysql-0` Pod:

```zsh
kubectl exec -it mysql-0 -n mysql -- sh
```

Then, inside the `mysql-0` Pod, connect to MySQL:

```bash
mysql -u root --password=1234
```

It is better to use `-p` instead of `--password=<your_password>`. In this case, you will need to enter the password in the terminal, but it will not be saved in the command history.

However, this is an educational task, so keep this security recommendation in mind.

Then run the following query to check all tasks:

```sql
SELECT * FROM app_db.lists_todo;
```