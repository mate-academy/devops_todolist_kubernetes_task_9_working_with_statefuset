# ✅ Instructions to Validate the Deployment

This document describes how to verify that all the Kubernetes resources were correctly deployed.

---

## 1. Verify Namespaces
Make sure both namespaces exist:
```bash
kubectl get ns
You should see:

nginx
Копировать код
mysql
todoapp
2. Verify StatefulSet
Check that the MySQL StatefulSet is running with 3 replicas:

bash
Копировать код
kubectl get statefulset -n mysql
Expected output:

sql
Копировать код
mysql   3/3   Running
3. Verify Headless Service
Ensure the headless service exists and has no ClusterIP:

bash
Копировать код
kubectl get svc -n mysql mysql-headless -o yaml | grep clusterIP
Expected:

makefile
Копировать код
clusterIP: None
4. Verify Secrets
Check that the secret for the todoapp contains DB credentials:

bash
Копировать код
kubectl describe secret app-secret -n todoapp
Expected keys:

pgsql
Копировать код
SECRET_KEY, NAME, USER, PASSWORD, HOST
5. Verify Deployment
Check that the todoapp pods are running:

bash
Копировать код
kubectl get pods -n todoapp
Expected:

sql
Копировать код
todoapp-xxxxx   1/1   Running
6. Verify DB Connection
Connect into a todoapp pod and check the DB host resolves:

bash
Копировать код
kubectl exec -it -n todoapp deploy/todoapp -- nslookup mysql-0.mysql-headless.mysql.svc.cluster.local
Expected:

pgsql
Копировать код
Name:   mysql-0.mysql-headless.mysql.svc.cluster.local
Address: 10.x.x.x
7. Verify Application Health
Check liveness and readiness endpoints:

bash
Копировать код
kubectl port-forward -n todoapp svc/todoapp-service 8080:80
curl http://localhost:8080/api/health
Expected response:
{"status": "healthy"}

8. Clean up
When done testing:

bash
Копировать код
kubectl delete ns mysql todoapp