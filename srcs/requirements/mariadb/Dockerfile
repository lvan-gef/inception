FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# MariaDB configuration
COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/db_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/db_setup.sh

# Create directory for socket
RUN mkdir -p /var/run/mysqld \
    && chown mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

EXPOSE 3306

CMD ["/usr/local/bin/db_setup.sh"]
