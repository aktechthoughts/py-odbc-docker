FROM python:3

WORKDIR /usr/src/app

# Copy over the drivers
# MySQL ODBC Ansi
COPY drivers/mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit.tar.gz .
# Oracle 11.2
COPY drivers/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm .
COPY drivers/oracle-instantclient11.2-odbc-11.2.0.4.0-1.x86_64.rpm .
# Oracle 12.2
COPY drivers/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm .
COPY drivers/oracle-instantclient12.2-odbc-12.2.0.1.0-2.x86_64.rpm .

RUN apt-get update

# unixODBC
RUN apt-get install -y unixodbc-dev unixodbc-bin unixodbc

# The oracle base driver needs this
RUN apt-get install -y libaio1

# Needed to install the oracle .rpm files
RUN apt-get install -y alien

# MySQL ODBC Ansi driver
RUN tar xvzf mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit.tar.gz \
    && ./mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit/bin/myodbc-installer -d -a -n "MySQL ODBC 5.3 Ansi Driver" \
        -t "DRIVER=/usr/src/app/mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit/lib/libmyodbc5a.so"

# Oracle ODBC drivers

# Oracle 11.2
# 1. Install the oracle instant client
RUN alien -i oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
RUN alien -i oracle-instantclient11.2-odbc-11.2.0.4.0-1.x86_64.rpm
# 2. Setup the client
ENV LD_LIBRARY_PATH /usr/lib/oracle/11.2/client64/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
# 3. Make sure links are set
RUN ldconfig
# 4. Use the myodbc-installer to install the driver
RUN ./mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit/bin/myodbc-installer -d -a -n "Oracle 11.2" -t "DRIVER=/usr/lib/oracle/11.2/client64/lib/libsqora.so.11.1"

# Oracle 12.2
# 1. Install the oracle instant client
RUN alien -i oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm
RUN alien -i oracle-instantclient12.2-odbc-12.2.0.1.0-2.x86_64.rpm
# 2. Setup the client
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.2/client64/lib/${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
# 3. Make sure links are set
RUN ldconfig
# 4. Use the myodbc-installer to install the driver
RUN ./mysql-connector-odbc-5.3.9-linux-ubuntu16.04-x86-64bit/bin/myodbc-installer -d -a -n "Oracle 12.2" -t "DRIVER=/usr/lib/oracle/12.2/client64/lib/libsqora.so.12.1"

# Install pyodbc
RUN pip install pyodbc