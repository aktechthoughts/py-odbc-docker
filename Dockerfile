FROM python:3


#Install FreeTDS  and dependencies for PyODBC
#FreeTDS is a set of libraries for Unix and Linux that allows your programs 
#to natively talk to Microsoft SQL Server and Sybase databases


RUN apt-get update \
 && apt-get install unixodbc unixodbc-dev unixodbc-bin -y \
 && apt-get install tdsodbc -y \ 
 && apt-get install freetds-common freetds-bin freetds-dev -y \
 && apt-get install libaio1 alien -y \
 && apt-get clean -y


ADD drivers/odbcinst.ini /etc/
ADD drivers/odbc.ini /etc/

ADD drivers/freetds.conf /tmp
RUN cat /tmp/freetds.conf >> /etc/freetds/freetds.conf
RUN rm /tmp/freetds.conf

# MySQL ODBC Ansi
COPY drivers/mysql-connector-odbc-5.3.10-linux-ubuntu16.04-x86-64bit.tar.gz /tmp

# MySQL ODBC Ansi driver
WORKDIR /tmp
RUN tar xvzf /tmp/mysql-connector-odbc-5.3.10-linux-ubuntu16.04-x86-64bit.tar.gz  \
    && ./mysql-connector-odbc-5.3.10-linux-ubuntu16.04-x86-64bit/bin/myodbc-installer -d -a -n "MySQL ODBC 5.3 Ansi Driver" \
        -t "DRIVER=/usr/src/app/mysql-connector-odbc-5.3.10-linux-ubuntu16.04-x86-64bit/lib/libmyodbc5a.so"

# Oracle 18.5
COPY drivers/oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm /tmp
COPY drivers/oracle-instantclient18.5-odbc-18.5.0.0.0-3.x86_64.rpm /tmp


# Oracle 18.5
# 1. Install the oracle instant client
RUN alien -i oracle-instantclient18.5-basic-18.5.0.0.0-3.x86_64.rpm
RUN alien -i oracle-instantclient18.5-odbc-18.5.0.0.0-3.x86_64.rpm
# 2. Setup the client
ENV LD_LIBRARY_PATH /usr/lib/oracle/18.5/client64/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
# 3. Make sure links are set
RUN ldconfig
# 4. Use the myodbc-installer to install the driver
RUN ./mysql-connector-odbc-5.3.10-linux-ubuntu16.04-x86-64bit/bin/myodbc-installer -d -a -n "Oracle 18.5" -t "DRIVER=/usr/lib/oracle/18.5/client64/lib/libsqora.so.18.5"


# install pyodbc (and, optionally, sqlalchemy)
RUN pip install --trusted-host pypi.python.org pyodbc==4.0.26 sqlalchemy==1.3.5

RUN mkdir /app
ADD app.py /app

WORKDIR /app
