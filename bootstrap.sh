kind create cluster --config cluster.yml
kubectl config set-context --current --namespace=todoapp
kubectl create ns mysql 
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-configMap.yml
kubectl apply -f .infrastructure/statefulSet.yml
kubectl apply -f .infrastructure/deployment.yml
