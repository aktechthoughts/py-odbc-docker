import pyodbc

#connection = pyodbc.connect('Driver=FreeTDS;Server=analyticsportal-dev.cjgyin6ppjdg.ap-south-1.rds.amazonaws.com;Database=adidas_dna;UID=ap_developer;PWD=Adidas123;TDS_VERSION=8.0')
connection = pyodbc.connect('DSN=mysql;UID=mssql_admin;PWD=1nsecure')

cursor = connection.cursor()

cursor.execute("SELECT  name FROM kpis;;")
for row in cursor.fetchall():
    print(row.name)
