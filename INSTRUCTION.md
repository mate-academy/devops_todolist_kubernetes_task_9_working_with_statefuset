# INSTRUCTION.md

# Validation

## 1. Run the deployment script

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## 2. Verify resources in the `mysql` namespace

```bash
kubectl get statefulset,pods,svc -n mysql
```

Verify that:

- `todoapp-mysql` has **3/3** replicas running.
- The `mysql-headless` Service exists.

## 3. Verify Secrets and Required Keys

Ensure the `app-secret` is created in both namespaces and contains the required connection data.

```bash
# MySQL namespace
kubectl get secret app-secret -n mysql -o jsonpath='{.data}'

# ToDo application namespace
kubectl get secret app-secret -n todoapp -o jsonpath='{.data}'
```

Expected keys:

- `NAME`
- `USER`
- `PASSWORD`
- `HOST`

The `todoapp` namespace should also contain:

- `SECRET_KEY`

## 4. Verify the application deployment and standalone pod

```bash
kubectl get pods -n todoapp
```

Verify that both the Deployment pod and the standalone pod (`todoapp-standalone-pod`) are in the **Running** state.

## 5. Verify database connectivity

Check the application logs to confirm that both workloads successfully connect to `todoapp-mysql-0`.

```bash
# Deployment logs
kubectl logs deployment/todoapp -n todoapp

# Standalone pod logs
kubectl logs pod/todoapp-standalone-pod -n todoapp
```
