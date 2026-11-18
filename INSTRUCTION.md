# Instructions on how to validate the changes
# 1. Create the cluster
kind create cluster --config cluster.yml

# 2. Deploy the application
chmod +x bootstrap.sh
./bootstrap.sh

# 3. Check namespaces
kubectl get namespaces
# Expected namespaces:
# mysql
# todoapp

# 4. Check MySQL resources
kubectl get statefulset -n mysql
kubectl get pods -n mysql
kubectl get svc -n mysql
kubectl get pvc -n mysql
# Expected:
# StatefulSet mysql has 3 replicas;
# pods mysql-0, mysql-1, mysql-2 are running;
# Service mysql has CLUSTER-IP: None;
# three PVCs are created.

# 5. Check the application
kubectl get deployment -n todoapp
kubectl get pods -n todoapp
# All application pods should be Running and Ready.

# 6. Check the application logs
kubectl logs -n todoapp deployment/todoapp
# There should be no database connection errors.

# 7. Open the application locally
kubectl port-forward deployment/todoapp 8080:8080 -n todoapp
# Open:
# http://localhost:8080/

# 8. Validate Kubernetes manifests
kubectl apply --dry-run=client -f statefulSet.yml
kubectl apply --dry-run=client -f deployment.yml