Запусти кластер:
./bootstrap.sh
	•	Перевір namespace:
kubectl get ns
	•	Перевір статус StatefulSet і Pod-ів:
kubectl get statefulsets -n mysql
kubectl get pods -n mysql
	•	Перевір статус Deployment і Pod-ів додатку:
kubectl get deployments -n default
kubectl get pods -n default
	•	Перевір логи MySQL Pod:
kubectl logs mysql-0 -n mysql
	•	Перевір, чи додаток підключається до MySQL: перевір логи подів додатку:
kubectl logs -l app=todoapp -n default