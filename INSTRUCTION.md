### Validating:
### 1. Port-forward service
```angular2html
kubectl port-forward -n todoapp service/todoapp-service 8001:80
```
Get http in local browser: http://localhost:8001
and add new tasks

### 2. For validating mount volumes


1. Run shell inside pod(container):
```angular2html
kubectl exec mysql-0 -n mysql -it -- sh
```
2. Local log to mysql app_db:
    ```
    mysql -u app_user -pPASSWORD app_db
    ```
   and Select records from tables to validate it.