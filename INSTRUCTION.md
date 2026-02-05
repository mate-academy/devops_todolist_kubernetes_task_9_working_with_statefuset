Інструкція з розгортання та перевірки

Переконайтесь, що на машині встановлені Docker, kubectl та kind.

У корені репозиторію виконайте chmod +x bootstrap.sh, після чого запустіть ./bootstrap.sh.

Скрипт автоматично створить kind-кластер з cluster.yml, застосує всі Kubernetes-маніфести та розгорне MySQL (StatefulSet з 3 репліками) і застосунок.

Дочекайтесь завершення розгортання MySQL (kubectl rollout status statefulset/app-statefull -n mysql).

Перевірте, що ресурси створені: kubectl get all -n mysql та kubectl get all -n todoapp.

Переконайтесь, що застосунок має змінні середовища для підключення до БД (NAME, USER, PASSWORD, HOST) і підключається до app-statefull-0.app-headless.mysql.svc.cluster.local.

За потреби перевірте доступність сервісу застосунку через NodePort або Service, визначений у маніфестах.