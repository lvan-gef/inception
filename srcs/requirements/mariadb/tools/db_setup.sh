#!/bin/bash
SQLPATH="/var/lib/mysql"

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    # Initialize MySQL data directory
    mysql_install_db --user=mysql --datadir=${SQLPATH}

    # Start MySQL service temporarily
    mysqld_safe --datadir=${SQLPATH} &

    # Wait for MySQL to be ready
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    # Create database and user
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Stop MySQL
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
fi

# Start MySQL
exec mysqld_safe --datadir=${SQLPATH}
