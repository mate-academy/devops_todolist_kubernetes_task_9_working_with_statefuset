* To validate the changes:
    1. run `./bootstrap.sh` script 
    2. Connect to mysql container in pod:
       ```bash
        kubectl exec -nmysql -it my-statefullset-0 --- sh
       ```
    3. Connect to mysql db:
      ```bash
      mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD"
      ```