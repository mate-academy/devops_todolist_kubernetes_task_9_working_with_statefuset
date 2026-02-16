Run: kind create cluster --config cluster.yml

Run: bash bootstrap.sh

kubectl get pods -n mysql (expect 3 pods: mysql-0, mysql-1, mysql-2 with READY 1/1)

kubectl get statefulset mysql -n mysql (check Can StatefulSet create 3 pods exist)
kubectl get svc -n mysql(check headless service for statefulSet)

Go to browser (nodePort) http://localhost:30007