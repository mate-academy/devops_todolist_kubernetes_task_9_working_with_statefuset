
# Validating Data Persistence in MySQL Database

## Verification Steps

1. Go to the Todoapp http://localhost:30007

2. Add a todo

1. **Connect to MySQL Pod**
    ```bash
    kubectl -n mysql exec -it <mysql-pod-name> -- bash
    ```

2. **Verify Test Data**
    ```sql
    SELECT * FROM todos;
    ```

3. **Delete and Recreate Pod**
    ```bash
    kubectl -n mysql delete pod <mysql-pod-name>
    # StatefulSet will recreate it with same PVC
    ```

4. **Verify Data Remains**
    ```bash
    kubectl -n mysql exec -it <mysql-pod-name> -- bash
    ```
    ```sql
    SELECT * FROM todos;
    ```

5. **Check PersistentVolume Status**
    ```bash
    kubectl get pvc -n mysql
    kubectl get pv
    ```
6. **Refresh the page in the todoapp**

## Expected Results
- Data persists after pod deletion
- Same PVC remains bound to new pod instance
- TodoApp retrieves existing records without loss