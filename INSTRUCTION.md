How to validate the changes?
First you need to get pod name.
kubectl get pods -n mysql
kubectl get pods -n todoapp
First you need to get pods name.
POD=$(kubectl get pods -n todoapp -o jsonpath='{.items[1].metadata.name}'))
Run in browser http://localhost:30007
Or kubectl logs  $POD.
If you see website or "[30/Jun/2026 14:51:01] "GET /api/health HTTP/1.1" 200 9" aplication is working.
kubectl run mysql-client --image=mysql:8.0 -it -n mysql -- sh
kubectl exec -n mysql mysql-0 -- mysql -u root -p -e "SHOW DATABASES;"
If you see database's name it's working.
