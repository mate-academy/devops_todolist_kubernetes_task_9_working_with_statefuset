# Validation Instructions

## 1. Check the MySQL namespace

kubectl get namespace mysql

## 2. Check the StatefulSet

kubectl get statefulset mysql -n mysql

Expected:
- 3 replicas
- 3 ready replicas

## 3. Check MySQL pods

kubectl get pods -n mysql

Expected:
- mysql-0
- mysql-1
- mysql-2
- all pods should be Running and Ready

## 4. Check the headless Service

kubectl get service mysql -n mysql

The Service should have:
- ClusterIP: None
- port: 3306

## 5. Check StatefulSet PVCs

kubectl get pvc -n mysql

Expected:
- mysql-data-mysql-0
- mysql-data-mysql-1
- mysql-data-mysql-2
- all PVCs should be Bound

## 6. Check StatefulSet configuration

kubectl get statefulset mysql -n mysql -o yaml

Verify:
- replicas: 3
- MySQL credentials are loaded from mysql-secret
- livenessProbe is configured
- readinessProbe is configured
- CPU and memory requests/limits are configured
- init.sql is mounted into /docker-entrypoint-initdb.d
- volumeClaimTemplates is configured

## 7. Check application Deployment

kubectl get deployment todoapp -n todoapp

kubectl rollout status deployment/todoapp -n todoapp

## 8. Check application database configuration

kubectl exec -n todoapp deployment/todoapp -- python manage.py shell -c "from django.db import connection; print(connection.settings_dict['ENGINE']); print(connection.settings_dict['HOST']); print(connection.settings_dict['NAME']); print(connection.introspection.table_names())"

Expected:
- database engine: django.db.backends.mysql
- host: mysql-0.mysql.mysql.svc.cluster.local
- database: todoapp
- Django tables should be present

## 9. Check MySQL database

kubectl exec -n mysql mysql-0 -- mysql -u root -prootpassword -e "SHOW TABLES FROM todoapp;"

Expected:
Django application tables should be present.

## 10. Validate all resources

kubectl get all -n mysql
kubectl get all -n todoapp

All required resources should be successfully deployed.
