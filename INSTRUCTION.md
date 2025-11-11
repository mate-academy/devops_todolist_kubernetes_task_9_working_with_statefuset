# Запуск Kubernetes кластера
kind create cluster --config=cluster.yml

# Переконайтесь, що кластер запущено:
kubectl cluster-info

# Розгортання MySQL StatefulSet
kubectl create namespace mysql
kubectl apply -f .infrastructure/statefulSet.yml

# Перевірте, що StatefulSet запущений і має 3 репліки:
kubectl get pods -n mysql -l app=mysql
kubectl get statefulset -n mysql

# Переконайтесь, що PVC створені і прив'язані:
kubectl get pvc -n mysql

# Розгортання ToDo App Deployment
kubectl create namespace todoapp
kubectl apply -f .infrastructure/deployment.yml

# Перевірте статус подів:
kubectl get pods -n todoapp -l app=todoapp

# Перевірка роботи додатку
# Знайдіть ім'я пода ToDo app:
kubectl get pods -n todoapp -l app=todoapp

# Перевірте логи:
kubectl logs -n todoapp <pod_name>

# Підключіться до додатку (потрібно налаштувати портфорвардинг):
kubectl port-forward -n todoapp <pod_name> 8080:8080

# Відкрийте браузер і перейдіть за адресою: http://localhost:8080
# Перевірка стану MySQL з подів
# Переконайтесь, що 0-й под MySQL працює і відповідає на ping:
kubectl exec -n mysql mysql-0 -- mysqladmin ping -uroot -p$MYSQL_ROOT_PASSWORD

# Очистка, щоб видалити все:
kubectl delete namespace mysql todoapp
kind delete cluster