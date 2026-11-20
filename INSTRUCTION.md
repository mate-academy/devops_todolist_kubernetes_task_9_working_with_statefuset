# Task 9 — Django ToDo + MySQL StatefulSet (kind)

## Overview

The Kubernetes cluster is created using `kind` and `.infrastructure/cluster.yml`.

- Namespace `mysql`: a three-replica MySQL StatefulSet, a headless Service, a Secret, and a ConfigMap with `init.sql`.
- Namespace `todoapp`: the Django Deployment configured to connect to the first MySQL Pod.
- Django receives `NAME`, `USER`, `PASSWORD`, and `HOST` from Kubernetes Secret `app-secret`.
- Each MySQL Pod has its own persistent volume claim created through `volumeClaimTemplates`.

The first MySQL Pod has the stable DNS name:

```text
mysql-0.mysql.mysql.svc.cluster.local
```

**Note:** Three MySQL StatefulSet replicas are three separate MySQL instances, not an automatically replicated MySQL database cluster. Django connects only to `mysql-0`, as required by the assignment.

## Prerequisites

- Docker Desktop running
- `kind` installed
- `kubectl` installed
- The repository contains the updated `src/Dockerfile`, `src/requirements.txt`, and `src/todolist/settings.py` configured for MySQL
- The following manifests exist in `.infrastructure/`:

```text
cluster.yml
st-secret.yml
st-configMap.yml
st-service.yml
statefulSet.yml
secret.yml
deployment.yml
```

For the local setup, `cluster.yml` uses an API server address of `127.0.0.1` and port `16443`, avoiding the Docker Desktop Kubernetes API port `6443`.

## 1. Deploy all resources

Run from the repository root:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

The script:

1. Creates the `task9` kind cluster if it does not already exist.
2. Waits until the Kubernetes nodes are Ready.
3. Creates the `mysql` and `todoapp` namespaces if necessary.
4. Applies the MySQL Secret, `init.sql` ConfigMap, headless Service, and StatefulSet, then waits for its three replicas.
5. Builds `todoapp:task9` from `./src` and loads the image directly into the kind cluster (no Docker Hub push required).
6. Applies the Django Secret and Deployment and waits for rollout.
7. Runs `python manage.py migrate --noinput` in the Django container.
8. Prints the state of the deployed resources.

The script can be rerun without deleting the cluster. **It does not erase existing MySQL data or PVCs.** The MySQL Docker entrypoint runs scripts in `/docker-entrypoint-initdb.d` only on initialization of a new, empty data directory; editing `init.sql` later will not rerun it against existing volumes.

Commands below use `--context kind-task9` to ensure that operations target the correct cluster instead of Docker Desktop Kubernetes.

## 2. Validate the cluster

```bash
kind get clusters
kubectl --context kind-task9 get nodes
```

Expected: the `task9` cluster exists, with one control-plane and two worker nodes showing `Ready`.

## 3. Validate the MySQL StatefulSet and persistent storage

```bash
kubectl --context kind-task9 -n mysql get statefulset mysql
kubectl --context kind-task9 -n mysql get pods
kubectl --context kind-task9 -n mysql get pvc
```

Expected:

- StatefulSet `mysql`: `READY 3/3`.
- Pods `mysql-0`, `mysql-1`, `mysql-2`: each `1/1 Running`.
- Claims `data-mysql-0`, `data-mysql-1`, `data-mysql-2`: each `Bound`, requesting `2Gi`.

Confirm the MySQL probes, resource limits, and ConfigMap mount:

```bash
kubectl --context kind-task9 -n mysql describe pod mysql-0
```

## 4. Validate the headless Service

```bash
kubectl --context kind-task9 -n mysql get svc mysql
```

Expected: `CLUSTER-IP` is `None` and the MySQL Service exposes port `3306/TCP`.

## 5. Validate SQL initialization

Show the tables created inside `app_db` by the mounted initialization script:

```bash
kubectl --context kind-task9 -n mysql exec mysql-0 -- \
  sh -c 'MYSQL_PWD="$MYSQL_PASSWORD" mysql -u "$MYSQL_USER" "$MYSQL_DATABASE" -e "SHOW TABLES;"'
```

Expected: the `counter` table appears if the supplied `init.sql` created it. The password is taken from the Pod's environment rather than typed on the command line.

## 6. Validate the Django Deployment and database connection

```bash
kubectl --context kind-task9 -n todoapp get deployment todoapp
kubectl --context kind-task9 -n todoapp get pods
kubectl --context kind-task9 -n todoapp logs deployment/todoapp --tail=50
```

Expected: the Deployment has `1/1` available Pod with no startup errors.

Check the database actually used by Django:

```bash
kubectl --context kind-task9 -n todoapp exec deployment/todoapp -- \
  python manage.py shell -c \
  "from django.db import connection; c = connection.cursor(); c.execute('SELECT DATABASE()'); print(c.fetchone())"
```

Expected output:

```text
('app_db',)
```

Confirm the Django migrations:

```bash
kubectl --context kind-task9 -n todoapp exec deployment/todoapp -- python manage.py showmigrations
```

Applied migrations are marked `[X]`.

Check that the expected Secret keys are present **without printing credentials**:

```bash
kubectl --context kind-task9 -n todoapp get secret app-secret \
  -o go-template='{{range $k, $v := .data}}{{$k}}{{"\n"}}{{end}}'
```

Expected keys: `SECRET_KEY`, `NAME`, `USER`, `PASSWORD`, `HOST`.

## 7. Access the Django application

In a terminal, run:

```bash
kubectl --context kind-task9 -n todoapp port-forward deployment/todoapp 8080:8080
```

From another terminal, test an endpoint that exists in this application's URL configuration. For example, if `/api/health` is implemented:

```bash
curl -i http://localhost:8080/api/health
```

A `404` means this particular route may not exist; check the application's `urls.py` before treating it as a deployment issue. Stop port-forwarding with `Ctrl+C`.

## 8. Troubleshooting

- **Pod `Pending`:** run `kubectl --context kind-task9 -n mysql describe pod mysql-0` and inspect `Events`, storage claims, and node resource capacity.
- **`ImagePullBackOff` for Django:** check `image: todoapp:task9` and `imagePullPolicy: IfNotPresent` in `deployment.yml`; rebuild/load the image with `docker build -t todoapp:task9 ./src` and `kind load docker-image todoapp:task9 --name task9`.
- **`CreateContainerConfigError`:** check that `app-secret` exists in namespace `todoapp` and includes all required keys.
- **MySQL connection error:** check the `HOST` Secret key (`mysql-0.mysql.mysql.svc.cluster.local`), database `app_db`, credentials, and readiness of `mysql-0`.
- **Missing Django tables:** rerun `kubectl --context kind-task9 -n todoapp exec deployment/todoapp -- python manage.py migrate --noinput`.

## 9. Submission

Verify and commit the files required by the assignment, then open a Pull Request from your fork. The principal files for Task 9 are:

```text
bootstrap.sh
INSTRUCTION.md
.infrastructure/cluster.yml
.infrastructure/st-secret.yml
.infrastructure/st-configMap.yml
.infrastructure/st-service.yml
.infrastructure/statefulSet.yml
.infrastructure/secret.yml
.infrastructure/deployment.yml
src/Dockerfile
src/requirements.txt
src/todolist/settings.py
```

Use only disposable local development credentials for this exercise. Never commit real passwords or production Django `SECRET_KEY` values to Git; Base64 encoding is not encryption. For a non-local deployment, use a secure method to provide secrets instead of storing them in a public repository.
