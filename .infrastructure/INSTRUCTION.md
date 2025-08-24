# Validation Instructions

## Deploy
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## Validate StatefulSet
```bash
kubectl get statefulset -n mysql
kubectl get pods -n mysql
kubectl get pvc -n mysql
```

## Validate MySQL Connection
```bash
kubectl exec -it mysql-0 -n mysql -- mysql -u root -p
```

## Validate Application
```bash
kubectl get deployment
kubectl get pods
```

## Check Secrets
```bash
kubectl get secrets
kubectl get secrets -n mysql
```