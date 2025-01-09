#!/bin/bash

# Hardcoded paths matching nginx.conf
SSL_CERT="/etc/nginx/ssl/inception.crt"
SSL_KEY="/etc/nginx/ssl/inception.key"

# Create SSL directory if it doesn't exist
mkdir -p /etc/nginx/ssl

# Generate SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout $SSL_KEY \
    -out $SSL_CERT \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=lvan-gef.42.fr"
