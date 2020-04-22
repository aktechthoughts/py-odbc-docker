import pyodbc

connection = pyodbc.connect('DSN=mssql;UID=mssql_admin;PWD=1nsecure')

cursor = connection.cursor()

cursor.execute("SELECT  name FROM tempdb.guest.kpis;;")
for row in cursor.fetchall():
    print(row.name)
