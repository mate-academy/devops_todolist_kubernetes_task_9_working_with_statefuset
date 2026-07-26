# Інструкція з розгортання та перевірки

# Запуск усіх ресурсів
Для автоматичного розгортання всіх ресурсів у кластері виконайте скрипт:
```bash
bash bootstrap.sh


# Перевірте, що всі поди та StatefulSet знаходяться в статусі Running:
kubectl get pods -n mysql
kubectl get statefulset -n mysql
kubectl get pvc -n mysql
kubectl get svc -n mysql

# Перевірте, що змінні оточення для підключення до бази даних зчитані з Secret:
kubectl exec -it deployment/todoapp -n todoapp -- env | grep -E "NAME|USER|PASSWORD|HOST"

# Перевірте логи додатка, щоб переконатися у підключенні до ноди бази даних:
kubectl logs -l app=todoapp -n todoapp
