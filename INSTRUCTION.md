# Instructions

## Deploy

Run the bootstrap script to create the cluster and deploy all resources:

    bash bootstrap.sh

## Validate

### 1. App is running

    kubectl get pods -n todoapp

Expected: STATUS `Running`, READY `1/1`

### 2. MySQL StatefulSet is running

    kubectl get pods -n mysql

Expected: 3 pods with STATUS `Running`, READY `1/1`
Pod names should be: `mysql-0`, `mysql-1`, `mysql-2`

### 3. App can connect to MySQL (mysql-0)

    kubectl exec -it -n todoapp deploy/todoapp -- env | grep DB_HOST

Expected output:

    DB_HOST=mysql-0.mysql.mysql.svc.cluster.local

### 4. DB credentials are injected from Secret

    kubectl exec -it -n todoapp deploy/todoapp -- env | grep -E "DB_NAME|DB_USER|DB_PASSWORD"

### 5. MySQL is initialized with init.sql

    kubectl exec -it mysql-0 -n mysql -- mysql -u app_user -p1234 app_db -e "SHOW TABLES;"

Expected: table `counter` exists

### 6. ConfigMap mounted as files

    kubectl exec -it -n todoapp deploy/todoapp -- ls -la /app/configs

### 7. Secret mounted as files

    kubectl exec -it -n todoapp deploy/todoapp -- ls -la /app/secrets