# How to validate the changes:

**1) Firstly check created pods, must be 3 pods:**

    kubectl get pods -n mysql 

**2) Then, go inside our first database pod and check database and table:**

    kubectl exec -it mysql-service-0 -n mysql -- bash

Inside pod:

    mysql -u root -p$MYSQL_ROOT_PASSWORD

And check created our database or no:

    SHOW DATABASES;
    USE app_db;
    SHOW TABLES;