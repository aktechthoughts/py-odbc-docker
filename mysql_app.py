import pyodbc

 
connection = pyodbc.connect("DSN=mysql;UID=mysql_admin;PWD=1nsecure")

cursor = connection.cursor()

cursor.execute("SELECT  name FROM kpis;")
for row in cursor.fetchall():
    print(row.name)
