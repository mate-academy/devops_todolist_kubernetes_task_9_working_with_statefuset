Run these and ensure outputs match expectations:

```bash
# after ./bootstrap.sh
kubectl get statefulset -n mysql
kubectl get pods -n mysql
kubectl get pvc -n mysql
kubectl get svc -n mysql

kubectl exec -n mysql mysql-0 -- ls -la /docker-entrypoint-initdb.d
kubectl exec -it <app-pod> -- ls -la <config-mount-path>
kubectl exec -it <app-pod> -- ls -la <secret-mount-path>
kubectl exec -it <app-pod> -- cat <secret-mount-path>/HOST
kubectl exec -it <app-pod> -- env | grep -E 'NAME|USER|PASSWORD|HOST'
kubectl logs <app-pod> --tail=200
# Basic app reachability:
kubectl run -it --rm curl-test --image=busyboxplus:curl --restart=Never --command -- \
  curl -sS -I http://<app-service>:<port>/health
