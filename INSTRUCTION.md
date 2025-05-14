# MySQL StatefulSet Deployment Validation

## Deployment Steps
1. Make the bootstrap script executable:
   ```bash
   chmod +x bootstrap.sh
   ```

2. Run the bootstrap script:
   ```bash
   ./bootstrap.sh
   ```

## Validation Steps

1. Verify the namespace creation:
   ```bash
   kubectl get namespace mysql
   ```

2. Verify the StatefulSet deployment:
   ```bash
   kubectl get statefulset -n mysql
   ```

3. Verify the pods are running:
   ```bash
   kubectl get pods -n mysql
   ```

4. Verify the headless service:
   ```bash
   kubectl get svc -n mysql
   ```

5. Verify the secrets:
   ```bash
   kubectl get secrets -n mysql
   ```

6. Verify the ConfigMaps:
   ```bash
   kubectl get configmaps -n mysql
   ```

7. Test MySQL connectivity:
   ```bash
   kubectl exec -it mysql-0 -n mysql -- mysql -u root -p
   ```
   Enter the root password when prompted.

8. Verify database initialization:
   ```bash
   kubectl exec -it mysql-0 -n mysql -- mysql -u root -p -e "USE tododb; SHOW TABLES;"
   ```

9. Verify the application can connect to MySQL:
   ```bash
   kubectl get pods -n mysql -l app=mysql
   ```
