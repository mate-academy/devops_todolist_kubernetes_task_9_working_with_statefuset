## Guideline

1. Run the `bootstrap.sh` script to deploy all resources:

## Instructions on how to validate

1. Check statefulset is alive

   kubectl get statefulsets -n mysql

2. Check todoapp is alive

   kubectl get deployment -n todoapp

3. Check mysql pods

   kubectl get pods -n mysql
