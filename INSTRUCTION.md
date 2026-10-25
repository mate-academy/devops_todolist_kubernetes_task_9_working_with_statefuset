1. How to validate the changes.

    - Check pods in todoapp namespace:

        kubectl get pods -n todoapp
    
    - Check connection app with mysql DB:

        kubectl exec -it <pod name> -n todoapp -- python manage.py shell -c "
            from django.db import connection
            with connection.cursor() as c:
                c.execute('SELECT DATABASE(), @@hostname')
                print(c.fetchone())
            "

    You must receive (mysql-0, todoapp_db) as result of command, where mysql pod name = mysql-0, mysql db name = todoapp_db