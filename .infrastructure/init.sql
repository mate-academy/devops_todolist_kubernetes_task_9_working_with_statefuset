CREATE DATABASE mydb;
CREATE USER 'myuser'@'%' IDENTIFIED BY "mypass";
GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'%';