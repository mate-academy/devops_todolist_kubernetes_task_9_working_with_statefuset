# Deployment and Validation Instructions

## Prerequisites
1. Kubernetes cluster set up using Kind.
2. Replace `<your-dockerhub-username>` with your Docker Hub username.

---

## Steps to Deploy

1. Run the `bootstrap.sh` script:
```bash
   ./bootstrap.sh
```
2. Verify that resources are created:
````
kubectl get statefulsets -n mysql
kubectl get pods -n mysql
kubectl get pods -n mateapp
````

## Validation Steps
1. Validate MySQL StatefulSet
   - Ensure 3 replicas are running:
        ````
        kubectl get pods -n mysql
        ````
   - Validate readiness and liveness:
        ````
        kubectl describe pod <pod-name> -n mysql
        ````
     
2. Validate ToDo App
   - Port-forward the ToDo app
        ````
        kubectl port-forward deployment/todoapp 8080:8080 -n mateapp
        ````  
   - Access the app at http://localhost:8080


3. Database Connection
    - Check logs to confirm the app connects to mysql-0:
        ````
        kubectl logs <todoapp-pod-name> -n mateapp
        ````
