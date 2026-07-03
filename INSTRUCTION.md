kubectl cluster-info
check cluster create from cluster.yml

kubectl config set-context --current --namespace=mysql

kubectl get secrets
kubectl describe secret mysql-secrets

kubectl get configmap
kubectl describe configmap mysql

kubectl get statefulset
kubectl describe statefulset mysql

kubectl get svc
check CLUSTER-IP = None

kubectl exec -it <mysql-pod> -- env | grep HOST
check HOST=mysql-0.mysql

kubectl get pods
check pods mysql-0, mysql-1, mysql-2 status running

kubectl get svc

open in brouser
http://localhost:30007
The application ToDo should open