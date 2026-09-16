apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql
  namespace: mysql
data:
  init.sql: |
    CREATE DATABASE IF NOT EXISTS app_db;
    GRANT ALL PRIVILEGES ON app_db.* TO 'user'@'%';
    FLUSH PRIVILEGES;