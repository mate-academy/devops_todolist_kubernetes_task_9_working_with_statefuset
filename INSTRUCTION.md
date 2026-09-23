1. Create cluster first
`kind create cluster --config .infrastructure/cluster.yml`

2. Run
```
bootstrap.sh
```
it will create the namespace and apply all manifests

3. Check that all pods are running
```
kubectl get pods -n todoapp
kubectl get pods -n mysql
```

4. Check that the app is running

4.1 Check did the mysql connect and has name mysql-mysql-0 or -1 -2 ... 
`kubectl get pvc -n mysql`

4.2. Get the node IP
```
kubectl get nodes -o wide
```

4.3. Open the app in a browser or curl it using the NodePort (30007)
```
curl http://<node-ip>:30008/api/health
```
a successful response confirms the app is running

5. Check that the ConfigMap data is mounted as files in the right order

5.1. Get the pod name
```
kubectl get pods -n todoapp
```

5.2. List the mounted config files
```
kubectl exec -n todoapp <pod-name> -- ls /app/configs
```

5.3. Print the content of the mounted config file and compare it with the ConfigMap
```
kubectl exec -n todoapp <pod-name> -- cat /app/configs/PYTHONUNBUFFERED
```

6. Check that the Secret data is mounted as a file

6.1. List the mounted secret files
```
kubectl exec -n todoapp <pod-name> -- ls /app/secrets
```

6.2. Print the content of the mounted secret file
```
kubectl exec -n todoapp <pod-name> -- cat /app/secrets/SECRET_KEY
```
