kind create cluster --config cluster.yml
chmod +x bootstrap.sh
./bootstrap.sh

kubectl get pods -n mysql

kubectl exec -n mysql mysql-0 -- env | grep MYSQL_

kubectl exec -n mysql mysql-0 -- ls /docker-entrypoint-initdb.d
kubectl exec -it -n mysql mysql-0 -- mysql -uroot -p<root-password> -e "SHOW DATABASES;"

kubectl get pvc -n mysql

kubectl delete pod mysql-1 -n mysql
kubectl get pods -n mysql -w

kubectl get pods -n <app-namespace>
kubectl logs -n <app-namespace> deploy/<app-deployment>

kubectl get nodes -o wide
curl http://localhost:30007/

kubectl exec -it -n mysql mysql-0 -- mysql -uroot -p<root-password> -e "SELECT * FROM <db>.<table>;"

kubectl get hpa -n <app-namespace>

