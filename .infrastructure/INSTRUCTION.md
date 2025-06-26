# Інструкції для завдання: MySQL StatefulSet та ToDo Deployment

Як застосувати ресурси

```bash
./bootstrap.sh
Перевірка роботи MySQL StatefulSet
 StatefulSet запрацював:


kubectl get sts -n mysql
kubectl get pods -n mysql
kubectl get svc -n mysql
Ви повинні бачити 3 репліки (mysql-0, mysql-1, mysql-2). Перевірте лог першого пода:


 перевірте, що база ShopDB створена:


kubectl exec -it mysql-0 -n mysql -- mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES;"

 Перевірка роботи ToDo Deployment

kubectl get deployments -n mysql
kubectl get pods -n mysql -l app=todoapp
kubectl logs deployment/todoapp -n mysql
Якщо застосунок працює, можна перевірити підключення:


kubectl exec -it <todoapp-pod> -n mysql -- curl http://$HOST:8080/health
Або зробити Port-forwarding:


kubectl port-forward svc/todoapp 8080:8080 -n mysql
curl http://localhost:8080/health