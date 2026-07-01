#Deployment Instructions
## 1. Deploy all resourcesRun the bootstrap script:
```bashbash bootstrap.sh```

## 2. Verify MySQL StatefulSetCheck pods in mysql namespace:

```bashkubectl get pods -n mysql```

_**Expected:

**_mysql-0

\mysql-1 

\mysql-2Check service:

```bashkubectl get svc -n mysql```

_**Expected:

**_mysql (ClusterIP: None)

## 3. Verify todoapp DeploymentCheck pods:

```bashkubectl get pods -n todoapp```

Check services:

```bashkubectl get svc -n todoapp```

## 4. Verify application connectivityForward port:

```bashkubectl -n todoapp port-forward svc/todoapp-service 8080:80```

Open in browser:http://localhost:8080

## 5. Verify environment variables inside pod
```bashkubectl exec -it <todoapp-pod-name> -n todoapp -- printenv | grep DB```

_**Expected variables:**_DB_NAME \DB_USER \DB_PASSWORD \DB_HOST

## 6. Verify MySQL initialization
```bashkubectl logs mysql-0 -n mysql```