# Django ToDo list
## Testing StatefulSet
Run this command to check, if namespace created.
```bash
kubectl get ns
```
Run this command to check status of statefulset.
```bash
kubectl get statefulset -n mysql
```
Run this command to check pods names. It should be mysql-0, mysql-1, mysql-2.
```bash
kubectl get pods -n mysql.
```
Checking if mysql is running 
```bash
kubectl logs mysql-0 -n mysql
```
Checking usage of db in app.
```bash
kubectl get pods -n todoapp
```
```bash
kubectl logs < pod-name > -n todoapp
```
Container shoud be in status running and have connections with db.