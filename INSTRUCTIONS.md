Інструкції з перевірки змін
Цей документ містить інструкції для перевірки коректності розгортання StatefulSet для MySQL та додатку, який підключається до бази даних.

1. Перевірка StatefulSet для MySQL
1.1. Перевірка статусу StatefulSet
Виконайте команду:

bash
kubectl get statefulsets -n mysql
Очікуваний результат:

StatefulSet mysql повинен мати 3 репліки (DESIRED, CURRENT, READY повинні бути 3).

1.2. Перевірка подів MySQL
Виконайте команду:

bash
kubectl get pods -n mysql
Очікуваний результат:

Поди повинні мати імена mysql-0, mysql-1, mysql-2.

Статус кожного поду повинен бути Running.

1.3. Перевірка логів MySQL
Перегляньте логи одного з подів:

bash
kubectl logs mysql-0 -n mysql
Очікуваний результат:

В логах повинні бути повідомлення про успішний запуск MySQL.

2. Перевірка додатку
2.1. Перевірка статусу Deployment
Виконайте команду:

bash
kubectl get deployments -n mysql
Очікуваний результат:

Deployment todoapp повинен мати 1 репліку (DESIRED, CURRENT, UP-TO-DATE, READY повинні бути 1).

2.2. Перевірка подів додатку
Виконайте команду:

bash
kubectl get pods -n mysql -l app=todoapp
Очікуваний результат:

Поди повинні мати статус Running.

2.3. Перевірка логів додатку
Перегляньте логи поду додатку:

bash
kubectl logs <todoapp-pod-name> -n mysql
Очікуваний результат:

В логах повинні бути повідомлення про успішне підключення до MySQL.

3. Перевірка підключення до бази даних
3.1. Підключення до бази даних
Підключіться до бази даних через MySQL клієнт:

bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p
Примітка: Пароль можна знайти в Secret mysql-secret.

3.2. Перевірка бази даних
Виконайте команди в MySQL клієнті:

sql
SHOW DATABASES;
USE mydatabase;
SHOW TABLES;
Очікуваний результат:

База даних mydatabase повинна існувати.

Таблиця tasks повинна бути створена.

4. Перевірка Service
4.1. Перевірка статусу Service
Виконайте команду:

bash
kubectl get services -n mysql
Очікуваний результат:

Service mysql повинен бути створений і мати тип ClusterIP.

5. Перевірка PersistentVolumeClaims (PVC)
5.1. Перевірка статусу PVC
Виконайте команду:

bash
kubectl get pvc -n mysql
Очікуваний результат:

PVC mysql-data-mysql-0, mysql-data-mysql-1, mysql-data-mysql-2 повинні бути в стані Bound.

6. Перевірка ConfigMap та Secrets
6.1. Перевірка ConfigMap
Виконайте команду:

bash
kubectl describe configmap app-config -n mysql
Очікуваний результат:

ConfigMap повинен містити ключі, які використовуються в додатку.

6.2. Перевірка Secrets
Виконайте команду:

bash
kubectl describe secret app-secret -n mysql
Очікуваний результат:

Secret повинен містити ключі NAME, USER, PASSWORD, HOST.

7. Перевірка монтування томів
7.1. Перевірка монтування ConfigMap
Виконайте команду, щоб перевірити, чи ConfigMap змонтований у контейнері:

bash
kubectl exec <todoapp-pod-name> -n mysql -- ls /app/configs
Очікуваний результат:

У директорії /app/configs повинні бути файли з ConfigMap.

7.2. Перевірка монтування Secrets
Виконайте команду, щоб перевірити, чи Secret змонтований у контейнері:

bash
kubectl exec <todoapp-pod-name> -n mysql -- ls /app/secrets
Очікуваний результат:

У директорії /app/secrets повинні бути файли з Secret.