> Використання **kind** + `kubectl`.

## 1) Кластер

kind create cluster --config cluster.yml || true

Застосувати маніфести
./bootstrap.sh

 Перевірити MySQL StatefulSet (namespace mysql)
 kubectl get pods -n mysql -l app=mysql
kubectl get statefulset -n mysql mysql
kubectl get svc -n mysql mysql -o yaml | grep -i clusterIP

Очікується: 3 поди (mysql-0, mysql-1, mysql-2) у стані Running/Ready; у сервісу clusterIP: None.

 Перевірити прив'язку застосунку до mysql-0
 kubectl get deployment todo-app
kubectl get secret todo-db-credentials -o yaml
Очікувані ключі секрета: NAME, USER, PASSWORD, HOST (HOST = mysql-0.mysql.mysql.svc.cluster.local).

 (Опційно) Тест конекшену до MySQL
 kubectl run sql-client --image=mysql:8.0 --restart=Never --rm -it -- bash -lc "mysql -h mysql-0.mysql.mysql.svc.cluster.local -u\"$(kubectl get secret todo-db-credentials -o jsonpath='{.data.USER}' | base64 -d)\" -p\"$(kubectl get secret todo-db-credentials -o jsonpath='{.data.PASSWORD}' | base64 -d)\" -e 'SHOW DATABASES;'"