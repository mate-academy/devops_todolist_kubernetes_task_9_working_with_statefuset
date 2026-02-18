# Validation Instructions

1. **Deployment:**
   - Execute the bootstrap script: `./bootstrap.sh`
   - Wait for all pods to reach the `Running` state. Use `kubectl get pods -A` to monitor.

2. **Check Logs (Fixing backtick issue):**
   - Run: `kubectl logs deploy/todoapp -n todoapp` ✅

3. **Database Connectivity:**
   - Check if MySQL pods are ready: `kubectl get pods -n mysql`
   - Test internal DNS: `kubectl exec -it -n todoapp deploy/todoapp -- nslookup mysql-0.mysql-headless.mysql.svc.cluster.local`

4. **External Access:**
   - Access the application at `http://localhost:30007` (NodePort).