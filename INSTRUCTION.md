# INSTRUCTION.md

## 1. Create and start the Kubernetes cluster

Run the bootstrap script from the project root:

```sh
./bootstrap.sh
```

This will:
- Create a kind cluster using `cluster.yml`
- Apply all required manifests in the correct order

---

## 2. Validate MySQL StatefulSet

Check that the MySQL StatefulSet is running and ready:

```sh
kubectl -n mysql get pods
kubectl -n mysql rollout status sts/mysql
```

All pods should be in the `Running` state.

---

## 3. Validate Django app deployment

Check that the Django app deployment is running and ready:

```sh
kubectl -n todoapp get pods
kubectl -n todoapp rollout status deploy/todoapp
```

---

## 4. Port-forward to access the Django app

Expose the Django app locally:

```sh
kubectl -n todoapp port-forward deploy/todoapp 8080:8000
```

Open [http://localhost:8000](http://localhost:8000) in your browser to verify the app is accessible.

---

## 5. Verify MySQL database initialization

Connect to the first MySQL pod and check that the `todolist` database exists:

```sh
kubectl -n mysql exec -it mysql-0 -- mysql -umyuser -pmypassword -e 'SHOW DATABASES;'
```

You should see `todolist` in the output.

---

## 6. Troubleshooting

- If any pod is not running, check logs:
  ```sh
  kubectl -n mysql logs mysql-0
  kubectl -n todoapp logs todoapp
  ```
- Ensure all secrets and configmaps exist in the correct namespaces:
  ```sh
  kubectl get secret -n mysql
  kubectl get configmap -n mysql
  kubectl get secret -n todoapp
  ```

---

## 7. Cleanup

To delete the cluster and all resources:

```sh
kind delete cluster
```

---

**End-to-end validation is complete when:**
- All pods are running
- The Django app is accessible
- The MySQL database is initialized and reachable from the app