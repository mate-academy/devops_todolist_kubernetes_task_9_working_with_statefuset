# Instructions to Validate Changes

1. **Deploy the cluster**:
    Run `kind create cluster --config cluster.yml` to set up the Kubernetes cluster.

2. **Deploy resources**:
    Run `./bootstrap.sh` to deploy all required resources, including the `StatefulSet` for MySQL and the ToDo application.

3. **Check the pods**:
    Run `kubectl get pods -n todoapp` to check the status of the deployed application.

4. **Check the database connection**:
    Use the following command to check if the application can connect to MySQL:
    - `kubectl logs <todoapp-pod-name> -n todoapp` (Check logs for DB connection errors).

5. **Verify the health probes**:
    - `kubectl get pods -n todoapp`
    - Check the liveness and readiness probes under `status`.

6. **Check MySQL StatefulSet**:
    - `kubectl get statefulsets -n mysql`
    - Verify that 3 replicas of MySQL are running correctly.
