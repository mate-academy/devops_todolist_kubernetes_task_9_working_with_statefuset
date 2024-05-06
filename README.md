***

## How to validate the changes

### Validate mysql

```
kubectl get statefulset -n mysql
```
```
kubectl get pods -n mysql
```
```
kubectl get svc -n mysql
```

### Validate todoapp

```
kubectl get deployment -n todoapp
```
```
kubectl get pods -n todoapp
```
```
kubectl get svc -n todoapp
```
