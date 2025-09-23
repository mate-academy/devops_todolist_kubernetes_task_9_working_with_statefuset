kubectl create namespace mysql

./bootstrap.sh

kubectl get pods -n mysql
kubectl logs mysql-0 -n mysql