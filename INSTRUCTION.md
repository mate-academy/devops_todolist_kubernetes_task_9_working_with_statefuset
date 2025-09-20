# Validation instructions — MySQL StatefulSet + app

Files are in `.infrastructure/`. Steps below assume you run from repo root.

## 1) Create cluster and deploy
```
chmod +x bootstrap.sh
./bootstrap.sh
```
This will:

create a kind cluster (if not exists),

create namespaces mysql and app,

create ConfigMap (init.sql), Secret (mysql-secret),

create headless Service mysql,

deploy StatefulSet mysql (3 replicas),

deploy app with secret-based DB config.

2) Verify StatefulSet & pods
```
kubectl get sts -n mysql
kubectl get pods -n mysql -o wide
```
You should see 3 pods: mysql-0, mysql-1, mysql-2. mysql-0 must be Ready.

3) Check init.sql was propagated
4) 
The init SQL is mounted into /docker-entrypoint-initdb.d inside each pod at first start:

```
kubectl exec -n mysql -it mysql-0 -- ls -la /docker-entrypoint-initdb.d
kubectl exec -n mysql -it mysql-0 -- cat /docker-entrypoint-initdb.d/init.sql
```
You should see init.sql content.

4) Check secrets env in pod
Inside a mysql pod the MYSQL_ROOT_PASSWORD env is set from Secret:

```
kubectl exec -n mysql -it mysql-0 -- printenv MYSQL_ROOT_PASSWORD
kubectl exec -n mysql -it mysql-0 -- printenv MYSQL_DATABASE
```
5) Confirm DB is initialized
Connect to mysql-0 and check the DB and user exist:

```
kubectl exec -n mysql -it mysql-0 -- mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES; SELECT User,Host FROM mysql.user LIMIT 10;"
```
(If mysql client not found in pod, use a temporary pod with mysql client.)

6) Verify DNS for 0-indexed pod
The app must connect to the specific pod mysql-0. Validate DNS resolves:

```
kubectl exec -n app -it $(kubectl get pod -n app -l app=todoapp -o jsonpath='{.items[0].metadata.name}') -- nslookup mysql-0.mysql
```
or
```
kubectl run -n app -it --rm --image=busybox dns-test -- nslookup mysql-0.mysql
```
7) Verify app reads connection information from Secret
Check app pod env:


```
kubectl get pods -n app -l app=todoapp
kubectl exec -n app -it <APP_POD> -- printenv DB_HOST DB_NAME DB_USER DB_PASSWORD
```
DB_HOST should be mysql-0.mysql (or as in app-db-secret).

8) Test app connectivity to mysql-0 (inside app pod)
From the app pod (if it has mysql client) try connecting:

````
kubectl exec -n app -it <APP_POD> -- sh -c 'nc -z -v mysql-0.mysql 3306 && echo "port open" || echo "cannot reach"'
````
Alternatively port-forward app and call an endpoint that uses DB.

9) Troubleshooting
If StatefulSet pods stuck Pending — check PVCs:
```
kubectl get pvc -n mysql
kubectl describe pvc -n mysql
```
If init.sql not present — check that ConfigMap mysql-init-sql exists in mysql namespace.

If app cannot connect — ensure app-db-secret has HOST mysql-0.mysql and app reads it.