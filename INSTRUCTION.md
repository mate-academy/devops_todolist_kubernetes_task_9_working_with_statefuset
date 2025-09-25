## Pre-requirements - run bootstrap script with command ```./bootstrap.sh```

## Validate that new resources exist:
- `kubectl get ns` - you should see mysql namespace
- `kubectl get configmaps -n mysql` - you should see mysql-config config map
- `kubectl get secrets -n mysql` - you should see mysql-secrets secret
- `kubectl get pods -n mysql` - you should see mysql pods in 'Running' state
- `kubectl get svc -n mysql` - you should see mysql service
- `kubectl get statefulset mysql -n mysql` - you should see mysql stateful set details
