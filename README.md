# Deployment Guide
1. **Create cluster**
    ```sh
    kind create cluster --config cluster.yml
    ```

2. **Apply all manifests**
    ```sh
    ./bootstrap.sh
    ```

## Verification

1. **Check Pods**
    ```sh
    kubectl get pods -n todoapp
    kubectl get pods -n mysql
    ```

2. **Check Logs**
    ```sh
    kubectl logs <name_of_pod> -n <namespace>
    ```

3. **Check browser**
    ```sh
    http://localhost:30007
    ```

4. **Connect to running pod shell**
    ```sh
    kubectl exec <one of running pod name> -it -n todoapp -- sh
    ```

5. **Check data in specific files**
    ```sh
    cat configs/PYTHONUNBUFFERED
    cat secrets/SECRET_KEY
    ```

6. **Connect to statefulSet**
    ```sh
    kubectl exec -it mysql-0 -n mysql -- sh
    ```

7. **Check databases**
    ```sh
    mysql -h mysql-0.todoapp-mysql -u root --password=1234 -e "SHOW DATABASES;"
    ```