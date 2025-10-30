Крок 1: Запуск та Розгортання Інфраструктури

Виконайте скрипт bootstrap.sh для створення кластера kind та послідовного розгортання всіх ресурсів:

./bootstrap.sh


Крок 2: Перевірка Просторів Імен та Секретів (Вимога 4.1, 5.2)

Переконайтеся, що простори імен mysql та todoapp створені, а секрети розгорнуті:

# Перевірка просторів імен
kubectl get ns 

# Перевірка секретів у 'mysql' namespace
kubectl get secret todoapp-mysql-secret -n mysql -o yaml 

# Перевірка секретів у 'todoapp' namespace
kubectl get secret app-secret -n todoapp -o yaml


Крок 3: Перевірка StatefulSet MySQL (Вимога 4.2, 4.7, 4.8)

Переконайтеся, що StatefulSet має 3 репліки, а Headless Service та Persistent Volume Claims (PVC) створені коректно:

# Перевірка 3 реплік StatefulSet та Headless Service
kubectl get all -n mysql

# Перевірка PVCs (VolumeClaimTemplates)
kubectl get pvc -n mysql


Очікуваний результат: Три поди (todoapp-mysql-0, -1, -2) повинні бути Ready, а також має бути три PVC.

Крок 4: Перевірка Deployment та Підключення (Вимога 5.1)

Перевірте логи застосунку, щоб підтвердити, що міграція пройшла успішно, і застосунок підключився саме до todoapp-mysql-0 (вимога 5.1):

# Перевірка статусу Deployment
kubectl get deployment todoapp -n todoapp

# Отримання імені пода Django (якщо їх більше одного, виберіть перший)
POD_NAME=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')

# Перевірка логів пода, щоб переконатися, що він успішно запустив міграції 
# та почав прослуховування трафіку (тобто підключився до БД)
kubectl logs $POD_NAME -n todoapp


Крок 5: Валідація Доступу до UI (End-to-End)

Отримайте URL NodePort, щоб переконатися, що весь ланцюжок (Django -> MySQL) працює, і застосунок доступний ззовні:

export NODE_IP=$(kubectl get nodes -o wide --no-headers | awk '{print $6}' | head -n 1)
export NODE_PORT=$(kubectl get svc todoapp-nodeport -n todoapp -o jsonpath='{.spec.ports[0].nodePort}')

echo "Application URL: http://$NODE_IP:$NODE_PORT"


Відкрийте отриману URL у вашому браузері.