# Instructions for Validation

1. Start the cluster: `kind create cluster --config cluster.yml`
2. Run `bootstrap.sh` to create the resources.
3. Check if all pods are running:
   ```bash
   kubectl get pods -n mysql
   kubectl get pods
4. Connect to the MySQL pod:
    ```bash
   kubectl exec -it mysql-0 -n mysql -- mysql -u root -p
    ```
5. Ensure that your ToDo application is running and successfully connecting to the database.







