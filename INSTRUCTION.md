## deploy application:
To deploy application run `./bootstrap.sh`

# to check if volumes are mounted
1. Get pod name by `kubectl get pods -n mysql`
2. Connect to pod by `kubectl exec -it mysql-0 -n mysql -- bash`
3. Connect to DB via mysql tool `mysql -p1234`.
4. Use DB: `use app_db;`
5. Enter command: `show tables;`