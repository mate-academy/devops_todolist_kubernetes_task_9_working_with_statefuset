Clone repository
git clone repository
go to folder repository

## DEPLOY
start file bootstrap
sh ./bootstrap.sh

## TESTING
kubectl config set-context --current --namespace=mateapp
kubectl get pods -n mateapp
kubectl get pods -n mysql
kubectl get pv -n mateapp
kubectl get pvc -n mateapp
kubectl get pv -n mysql
kubectl get pvc -n mysql