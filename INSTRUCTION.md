# Validation

1. Deploy all resources:
   - `bash bootstrap.sh`
2. Check MySQL StatefulSet:
   - `kubectl get pods -n mysql`
   - expect `mysql-0`, `mysql-1`, `mysql-2` in `Running`
3. Check app resources:
   - `kubectl get deploy,svc,hpa -n todoapp`
   - `kubectl get pods -n todoapp`
4. Validate DB env from Secret:
   - `kubectl exec -n todoapp deploy/todoapp -- printenv | grep -E '^(NAME|USER|PASSWORD|HOST)='`
5. Validate app health:
   - `kubectl port-forward -n todoapp svc/todoapp-service 8080:80`
   - open `http://localhost:8080/api/health`
