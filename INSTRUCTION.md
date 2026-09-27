To validate statefulSet run:
```
kubectl run mysql-client --image=mysql:8.0 -it -n mysql -- sh # enters the mysql environment to check database

mysql -h mysql-0.mysql -u root --password=1234 -e "INSERT INTO app_db.counter VALUES (1,1);"  # inserts the data into database

mysql -h mysql-0.mysql -u root --password=1234 -e   "SELECT * FROM app_db.counter; # shows the table, if there is the id=1 and value=1, StatefulSet is working
```