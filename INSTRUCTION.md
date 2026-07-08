# INSTRUCTION.md

# Validation

1. Clone the repository
2. Run the deployment script:

   ```bash
   chmod +x bootstrap.sh
   ./bootstrap.sh
   ```
3. Verify that all resources are created successfully:

   ```bash
   kubectl get pods -A
   kubectl get statefulsets -n mysql
   kubectl get svc -n mysql
   kubectl get pvc -n mysql
   ```
4. Confirm that:

* The MySQL StatefulSet (todoapp-mysql) has 3 Running replicas.
* The headless Service (mysql-headless) is created.
* All PersistentVolumeClaims (data-todoapp-mysql-*) are bound.
* The ToDo application is running in the todoapp namespace and successfully connected to todoapp-mysql-0:

