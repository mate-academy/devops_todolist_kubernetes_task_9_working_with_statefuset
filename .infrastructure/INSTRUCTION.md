To validate changes you have top map ports with command:

    To see app pod name use command:

        kubectl get deployments -n todoapp

    kubectl port-forward pod/<pod_name> 8000:8000

Then you can go to app in your browser by http://localhost:8000 and make notes, then you can check it inside of mysql_client by command:

    kubectl run mysql-client --image=mysql:8.0 -it -n mysql --sh

    And inseide of it use command:

        mysql -h mysql-0.mysql.mysql.svc.cluster.local -u root --password=rootpassword -e "SELECT * FROM app_db.todo"