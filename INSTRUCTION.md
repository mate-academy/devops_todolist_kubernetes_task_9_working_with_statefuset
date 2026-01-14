## Порядок розгортання інфраструктури

Для коректного запуску всіх компонентів використовуйте наступну черговість:

1. **Оточення**: Створення `namespace.yml`.
2. **Сховище**: Спочатку `pv.yml`, потім `pvc.yml` (щоб запит на об'єм знайшов свій диск).
3. **Конфігурація**: `confgiMap.yml` та `secret.yml` (паролі та змінні оточення).
4. **База даних**:
   - `st-service.yml` (Headless Service має бути першим для DNS-імен).
   - `statefulSet.yml` (запуск подів MySQL).
5. **Додаток**: 
   - `deployment.yml` (запуск контейнерів додатку).
   - `clusterIp.yml` та `nodeport.yml` (відкриття портів для доступу).
6. **Масштабування**: `hpa.yml` (Horizontal Pod Autoscaler).



## Як перевірити успішність:
- Перевірити стабільність імен бази: `kubectl get pods -n mysql -o wide`
- Перевірити доступ до бази з додатку: `kubectl logs <pod-name> -n todoapp`
- Перевірити роботу HPA: `kubectl get hpa -n todoapp`