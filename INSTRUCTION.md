# Validation Instructions

## Steps to Validate

### 1. Run the deployment script

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 2. Verify resources in the `mysql` namespace

```bash
kubectl get statefulset,pods,svc -n mysql
```

Verify that:

- `todoapp-mysql` has **3/3** replicas running.
- The `mysql-headless` Service exists.

### 3. Verify Secrets

```bash
kubectl get secrets -n todoapp
kubectl get secrets -n mysql
```

Verify that the required Secrets exist in both namespaces.

### 4. Verify the application

```bash
kubectl get pods -n todoapp
```

Ensure the application pod is in the **Running** state.

### 5. Verify database connectivity

```bash
kubectl logs deployment/todoapp -n todoapp
```
