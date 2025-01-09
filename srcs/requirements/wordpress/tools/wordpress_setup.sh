#!/bin/bash

if [ ! -f "wp-config.php" ]; then
    # Download WordPress
    wp core download --allow-root

    # Create wp-config.php
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --extra-php <<PHP
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_LOG', false );
define( 'WP_DEBUG_DISPLAY', false );
PHP

    # Install WordPress
    wp core install --allow-root \
        --url=${WP_URL} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    # Update directory permissions
    chown -R www-data:www-data /var/www/html
fi

# Start PHP-FPM
exec php-fpm7.4 -F
