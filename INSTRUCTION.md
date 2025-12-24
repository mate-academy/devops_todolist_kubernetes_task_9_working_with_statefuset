# **ToDo App & MySQL StatefulSet Deployment**

Цей репозиторій містить маніфести для розгортання відмовостійкої бази даних MySQL (StatefulSet) 
та ToDo застосунку в Kubernetes.

## Швидкий запуск

Для автоматичного розгортання всіх ресурсів (namespaces, secrets, configmaps, storage та workloads) виконайте скрипт:

```
chmod +x bootstrap.sh
./bootstrap.sh
```

## Перевірка працездатності

1. Після виконання `bootstrap.sh`, перевірте, що всі ресурси створені:

```
kubectl get all -n mysql
kubectl get all -n todoapp
```

### 1. Статус подів
Переконайтеся, що всі поди в обох неймспейсах працюють:

```
kubectl get pods -n mysql
kubectl get pods -n todoapp
``` 

### 2. Перевірка з'єднання з базою

Перевірте, що ToDo застосунок може підключитись до MySQL бази даних. Для цього перегляньте логи подів застосунку:

```
kubectl logs -l app=todoapp -n todoapp
```

### 3. Перевірка дисків (Persistence)

Перевірте, що для кожного поду бази створено окремий PVC:

```
kubectl get pvc -n mysql
```

### 4. Перевірка ініціалізації бази

Переконайтеся, що база даних todoappdb була створена автоматично:
```
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p -e "SHOW DATABASES;"
```