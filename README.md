# Django ToDo + MySQL StatefulSet

This learning project runs a Django ToDo application in Kubernetes and stores its
data in MySQL. The local cluster is created with `kind`.

## What is included

- a three-replica MySQL `StatefulSet` in the `mysql` namespace;
- one persistent volume claim per MySQL Pod;
- MySQL liveness and readiness probes plus CPU/memory requests and limits;
- a headless Service that gives Pods stable DNS names such as
  `mysql-0.mysql-service.mysql.svc.cluster.local`;
- an initialization SQL file mounted at `/docker-entrypoint-initdb.d`;
- a Django Deployment that reads `NAME`, `USER`, `PASSWORD`, and `HOST` from a
  Kubernetes Secret and connects specifically to `mysql-0`;
- a NodePort Service available at <http://localhost:30007>;
- an idempotent `bootstrap.sh` that creates the cluster, builds and loads the
  application image, and applies the manifests.

> The credentials in `.infrastructure/*.yml` are demonstration values for a
> local learning cluster. Do not use them in a real environment or commit real
> passwords to Git.

## Quick start

Prerequisites: Docker must be running, and `kind` and `kubectl` must be installed.

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

When both rollouts finish, open <http://localhost:30007>.

For a step-by-step explanation, validation commands, persistence test, and
cleanup instructions, see [INSTRUCTION.md](INSTRUCTION.md).

## Run without Kubernetes

When the four database environment variables are absent, Django deliberately
falls back to SQLite so the original application remains easy to explore.

```bash
cd src
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py test
python manage.py runserver
```

Then open <http://localhost:8000> or <http://localhost:8000/api/>.

## Important limitation

The assignment asks for three MySQL replicas, but a plain MySQL image does not
automatically replicate data between them. These are three independent MySQL
servers with separate disks. Django intentionally uses only `mysql-0`. Real
high-availability MySQL needs replication technology or an operator.
