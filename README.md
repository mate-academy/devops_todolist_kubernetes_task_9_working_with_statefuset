# Create a new cluster

kind create cluster --config cluster.yml

# Deploy all the required resources in the cluster

```
sh bootstrap.sh
```

# Check MySQL pods and logs
kubectl get pods -n mysql
kubectl logs <mysql-pod-name> -n mysql

# Verify database connection 
kubectl exec -it <pod-name> -- sh
mysql -h mysql-0.mysql-headless.mysql.svc.cluster.local -u mysqluser -p
