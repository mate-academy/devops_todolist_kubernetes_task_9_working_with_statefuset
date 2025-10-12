### 1. Run the bootstrap script:
```bash
./bootstrap.sh
```
This script will deploy the following resources: Cluster, PersistentVolume (pv.yml),  PersistentVolumeClaim (pvc.yml),  ConfigMap,  Secret, Deployment using the PVC, ConfigMap and Secret both for python Django app and MySQL db.
### 2. Validate that the application is running
Check the status of the pods:
```bash
kubectl get pods
kubectl describe pod <pod-name>
```
### 3. Validate PersistentVolume and PersistentVolumeClaim
```bash
kubectl get pv
kubectl get pvc
```
### 4. Validate Secret mount
```bash
ls -l /app/secrets
cat /app/secrets/<secret-file-name>
```

### 5. Validate MySQL DB health
```bash
kubectl run mysql-client --image=mysql:8.0 -it -n mysql -- sh
mysql -h mysql-0.mysql -u root -p"<password>" -e "USE app_db; SELECT * FROM lists_todo; SELECT * FROM lists_todolist;"
```
