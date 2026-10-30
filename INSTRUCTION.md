# Validation instructions

1. Deploy everything (creates the kind cluster and applies all manifests):

   ```
   ./bootstrap.sh
   ```

2. All 3 MySQL pods must be `Running` and `1/1 Ready`:

   ```
   kubectl get pods -n mysql
   ```

3. Each pod must have its own PVC (3 `Bound` claims):

   ```
   kubectl get pvc -n mysql
   ```

4. The headless service must expose the pods:

   ```
   kubectl get svc mysql-headless -n mysql
   kubectl get endpoints mysql-headless -n mysql
   ```

5. `init.sql` must have been applied (database `todolist` exists):

   ```
   kubectl exec -it mysql-0 -n mysql -- mysql -uroot -prootpassword -e "SHOW DATABASES;"
   ```

6. The app must be running and connected to `mysql-0` (Django tables exist after migration):

   ```
   kubectl get pods -n todoapp
   kubectl exec -it mysql-0 -n mysql -- mysql -utodouser -ptodopassword -e "SHOW TABLES;" todolist
   ```

7. Open the app at http://localhost:30007 , create an account and some tasks.

8. Check that data survives a pod restart:

   ```
   kubectl delete pod mysql-0 -n mysql
   kubectl wait --for=condition=ready pod/mysql-0 -n mysql --timeout=300s
   kubectl exec -it mysql-0 -n mysql -- mysql -utodouser -ptodopassword -e "SELECT COUNT(*) FROM lists_todolist;" todolist
   ```

   (Table names can be checked with `SHOW TABLES;` from step 6.)
