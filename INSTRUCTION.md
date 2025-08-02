# Check, If the namespaces were created

kubectl get namespaces

# Check the StatefulSet in mysql namespace

kubectl get statefulset -n mysql

# Check the pods in mysql namespace

kubectl get pods -n mysql

# Check the Secret and ConfigMap for mysql

kubectl get secret -n mysql
kubectl get configmap -n mysql

# Check the headless service for mysql

kubectl get svc -n mysql

# Check the Deployment for todoapp

kubectl get deployment -n todoapp

# Check the pods in todoapp namespace

kubectl get pods -n todoapp

# Check the Horizontal Pod Autoscaler

kubectl get hpa -n todoapp
