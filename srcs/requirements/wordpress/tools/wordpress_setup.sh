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

    # Set up basic widgets and menus
    wp widget reset sidebar-1 --allow-root
    wp widget add categories sidebar-1 --allow-root
    wp widget add recent-posts sidebar-1 --allow-root

    # Install and activate a blog-friendly theme (Twenty Twenty-One is good for blogs)
    wp theme install twentytwentyone --activate --allow-root

    wp post create --post_type=page \
        --post_title='Inception' \
        --post_content='Welcome to my inception home page my friend' \
        --post_status=publish
    wp option update show_on_front 'page' --allow-root
    HOMEPAGE_ID=$(wp post list --post_type=page --title='Inception' --field=ID --allow-root)
    wp option update page_on_front $HOMEPAGE_ID --allow-root
fi

# Start PHP-FPM
exec php-fpm7.4 -F
