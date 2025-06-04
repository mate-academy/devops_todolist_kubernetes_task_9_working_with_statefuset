
### Check Pod

kubectl get pods -n mysql


### Check Pod Logs

kubectl logs mysql-statefulset-0 -n mysql


### Config and Secret check 

kubectl exec -it mysql-statefulset-0 -n mysql -- /bin/sh


ls /app/secrets
cat /app/secrets/<file-name>


ls /app/secrets
cat /app/secrets/<file-name>



### DNS check

ping mysql-0.mysql-service.mysql
