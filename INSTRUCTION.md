check statefulset is added:

kubectl get statefulset -n mysql

check pods:

kubectl get pods -n mysql

mysql-0, mysql-1 and mysql-2 should appea in a while in strict order: first 0, then 1, then 2.

access http://localhost:30007/ and ensure site works as expected
update replicas to 2 in statefulSet.yml and ensure mysql-2 is gone only.

go to one of the hosts and ensure init.sql has been created

kubectl exec -n mysql -it mysql-0 -- sh

cd  /docker-entrypoint-initdb.d
ls <!-- you should see init.sql -->
cat init.sql 

You should see:

GRANT ALL PRIVILEGES ON app-db.* TO 'app_user'@'%';
use app-db;
sh-5.1# 