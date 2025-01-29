#!/bin/bash

if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root

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

    chown -R www-data:www-data /var/www/html

    wp post delete 1 --force --allow-root
    wp post delete 2 --force --allow-root

    wp widget reset sidebar-1 --allow-root
    wp widget add categories sidebar-1 --allow-root
    wp widget add recent-posts sidebar-1 --allow-root

    wp theme install twentytwentyone --activate --allow-root

    wp post create --post_type=page \
        --post_title='Inception' \
        --post_content='Welcome to my inception home page my friend' \
        --post_status=publish --allow-root

    wp option update show_on_front 'page' --allow-root
    HOMEPAGE_ID=$(wp post list --post_type=page --title='Inception' --field=ID --allow-root)
    wp option update page_on_front $HOMEPAGE_ID --allow-root

    wp option update blog_public 0 --allow-root
    wp option update default_pingback_flag 0 --allow-root
    wp option update default_ping_status 0 --allow-root
fi

exec php-fpm7.4 -F
