# Як перевірити проєкт (ELI5)

## Що тут відбувається

Уяви Kubernetes як будинок із двома кімнатами:

- кімната `mysql` — у ній живуть три пронумеровані бази даних: `mysql-0`,
  `mysql-1`, `mysql-2`;
- кімната `todoapp` — у ній живе Django-застосунок.

`StatefulSet` — це вихователь, який завжди повертає базам ті самі імена та
їхні власні диски. Headless Service — це телефонна книга. Завдяки їй застосунок
знаходить першу базу за незмінною адресою
`mysql-0.mysql-service.mysql.svc.cluster.local`.

`Secret` — закритий конверт із логіном, паролем, назвою та адресою бази.
`ConfigMap` — звичайна записка з несекретним налаштуванням. Файл `init.sql`
монтується в спеціальну теку MySQL і виконується лише під час першого запуску
на порожньому диску.

Важливо: три Pods у цьому навчальному прикладі **не копіюють дані один одному**.
Кожен має окрему базу й окремий диск, а Django працює тільки з `mysql-0`.

## 1. Перед стартом

Потрібні запущений Docker, `kind` і `kubectl`:

```bash
docker info >/dev/null && echo "Docker OK"
kind version
kubectl version --client
```

## 2. Розгорнути все однією командою

Виконуй із кореня репозиторію:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

Скрипт:

1. створить кластер `todo-cluster`, якщо його ще немає;
2. збере Docker-образ із поточним кодом;
3. завантажить образ усередину `kind`;
4. створить namespaces, Secrets, MySQL і Django;
5. дочекається готовності MySQL і застосунку.

Повторний запуск безпечний: ресурси будуть оновлені, а кластер не буде створено
вдруге.

## 3. Швидка перевірка

```bash
kind get clusters
kubectl get pods -n mysql
kubectl get pods -n todoapp
kubectl get statefulset -n mysql
kubectl get svc -n mysql
kubectl get pvc -n mysql
curl -i http://localhost:30007/api/health
curl -i http://localhost:30007/api/ready
```

Очікуваний результат:

- `kind get clusters` показує `todo-cluster`;
- `mysql-0`, `mysql-1`, `mysql-2` мають статус `Running` і `1/1` у колонці
  `READY`;
- `todoapp-...` має статус `Running` і `1/1`;
- StatefulSet показує `3/3` готових репліки;
- Service `mysql-service` має `CLUSTER-IP: None` — саме це означає headless;
- існують три PVC: по одному для кожного MySQL Pod;
- обидва HTTP-запити повертають `200 OK`.

Readiness endpoint навмисно повертає помилку перші 30 секунд після старту. Це
не поломка: Kubernetes просто ще не направляє користувачів у неготовий Pod.

## 4. Перевірити Secret і підключення до MySQL

Показуємо лише несекретні значення, які отримав Django:

```bash
kubectl exec -n todoapp deployment/todoapp -- printenv NAME USER HOST
```

Перевіряємо, що база `tododb` справді існує:

```bash
kubectl exec -n mysql mysql-0 -- \
  mysql -utodolist -ptodolistpassword -e "SHOW DATABASES;"
```

У результаті має бути `tododb`.

## 5. Перевірити, що диск переживає перезапуск Pod

Створимо маленьку контрольну таблицю та рядок:

```bash
kubectl exec -n mysql mysql-0 -- \
  mysql -utodolist -ptodolistpassword tododb \
  -e "CREATE TABLE IF NOT EXISTS persistence_test (value VARCHAR(30)); DELETE FROM persistence_test; INSERT INTO persistence_test VALUES ('still here');"
```

Видалимо лише Pod. StatefulSet автоматично створить його знову з тим самим
диском:

```bash
kubectl delete pod -n mysql mysql-0
kubectl wait --for=create pod/mysql-0 -n mysql --timeout=60s
kubectl wait --for=condition=Ready pod/mysql-0 -n mysql --timeout=180s
kubectl exec -n mysql mysql-0 -- \
  mysql -utodolist -ptodolistpassword tododb \
  -e "SELECT * FROM persistence_test;"
```

Якщо бачиш `still here`, постійне сховище працює.

## 6. Якщо щось не стартує

```bash
kubectl get pods -A
kubectl describe pod -n mysql mysql-0
kubectl logs -n mysql mysql-0
kubectl describe pod -n todoapp -l app=todoapp
kubectl logs -n todoapp deployment/todoapp
```

Найважливіші підказки знаходяться внизу `describe` у секції `Events` та в
останніх рядках `logs`.

## 7. Прибрати навчальний кластер

Ця команда видалить увесь кластер разом із навчальними даними:

```bash
kind delete cluster --name todo-cluster
```
