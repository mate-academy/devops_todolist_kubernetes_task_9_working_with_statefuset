# Instructions on how to validate the changes

# Deploy the application
chmod +x bootstrap.sh
./bootstrap.sh

# Check namespaces
kubectl get namespaces
# Expected namespaces:
# mysql
# todoapp

# Check MySQL resources
kubectl get statefulset -n mysql
kubectl get pods -n mysql
kubectl get svc -n mysql
kubectl get pvc -n mysql
# Expected:
# StatefulSet mysql has 3 replicas;
# pods mysql-0, mysql-1, mysql-2 are running;
# Service mysql has CLUSTER-IP: None;
# three PVCs are created.

# Check the application
kubectl get deployment -n todoapp
kubectl get pods -n todoapp
# All application pods should be Running and Ready.

# Check the application logs
kubectl logs -n todoapp deployment/todoapp
# There should be no database connection errors.

# Open the application locally
kubectl port-forward deployment/todoapp 8080:8080 -n todoapp
# Open:
# http://localhost:8080/

# Validate Kubernetes manifests
kubectl apply --dry-run=client -f statefulSet.yml
kubectl apply --dry-run=client -f deployment.yml