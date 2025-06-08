# INSTRUCTION.md

## ✅ Prerequisites

- Docker and [kind](https://kind.sigs.k8s.io/) installed
- kubectl installed and configured

---

## 🚀 Bootstrap Instructions

Run the following script to create a cluster and deploy all components:

```bash
./bootstrap.sh
```

This will:
- Create a Kubernetes cluster using `kind` with the provided `cluster.yml`
- Create namespaces (`mysql`, `todoapp`)
- Apply secrets and config maps
- Deploy MySQL as a StatefulSet with:
  - 3 replicas
  - mounted `init.sql` for initialization
  - `readinessProbe` and `livenessProbe`
  - resource requests and limits
  - PVCs via `volumeClaimTemplates`
- Deploy a headless service for MySQL
- Deploy the Django application configured to connect to `mysql-0`

---

## 🔍 Validation Instructions

### ✅ Check cluster status

```bash
kubectl get nodes
kubectl get pods -A
```

### ✅ Confirm MySQL StatefulSet

```bash
kubectl get statefulsets -n mysql
kubectl get pods -n mysql
kubectl describe sts mysql -n mysql
```

### ✅ Check MySQL init

Check that MySQL container initializes with `init.sql` mounted at `/docker-entrypoint-initdb.d`.

```bash
kubectl exec -it mysql-0 -n mysql -- ls /docker-entrypoint-initdb.d
```

### ✅ Application connection

Ensure that the Django app is able to connect to MySQL by inspecting logs:

```bash
kubectl logs -n todoapp deploy/todoapp
```

### ✅ Port-forward to access app

```bash
kubectl port-forward svc/todoapp-service -n todoapp 8000:8000
```

Visit [http://localhost:8000](http://localhost:8000)

---

## 🧹 Cleanup

```bash
kind delete cluster
```
