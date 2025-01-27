#!/bin/bash

if [ ! -f "wp-config.php" ]; then
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

    wp core install --allow-root \
        --url=${WP_URL} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    sleep 5
    wp user create ${WP_EXTRA_USER} ${WP_EXTRA_EMAIL} --role=subscriber --user_pass=${WP_EXTRA_PASSWORD} --allow-root || echo "Extra user already exists"

    # Update directory permissions
    chown -R www-data:www-data /var/www/html

    # Delete default content more specifically
    wp post delete 1 --force --allow-root  # Delete "Hello World" post
    wp post delete 2 --force --allow-root  # Delete "Sample Page"

    # Set up basic widgets and menus
    wp widget reset sidebar-1 --allow-root
    wp widget add categories sidebar-1 --allow-root
    wp widget add recent-posts sidebar-1 --allow-root

    wp theme install twentytwentyone --activate --allow-root

    # Create and set the homepage
    wp post create --post_type=page \
        --post_title='Inception' \
        --post_content='Welcome to my inception home page my friend' \
        --post_status=publish --allow-root

    # Make sure to set this as the front page right away
    wp option update show_on_front 'page' --allow-root
    HOMEPAGE_ID=$(wp post list --post_type=page --title='Inception' --field=ID --allow-root)
    wp option update page_on_front $HOMEPAGE_ID --allow-root

    # Make sure blog posts aren't showing on front
    wp option update blog_public 0 --allow-root
    wp option update default_pingback_flag 0 --allow-root
    wp option update default_ping_status 0 --allow-root
fi

# Start PHP-FPM
exec php-fpm7.4 -F
