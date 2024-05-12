# Django ToDo list

## Before testing
1. Get into the `.infrastructure` folder and run `bootstrap.sh` script

## Testing
1. App should be available at address: `http://localhost:30007/`
2. To validate the database write in the terminal: `kubectl exec mysql-client -it -n mysql -- sh`
3. `mysql -h mysql-0.mysql -u root --password=1234 -e "SELECT * FROM app_db`
