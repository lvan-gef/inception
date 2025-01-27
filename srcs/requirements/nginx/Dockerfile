FROM debian:bullseye

RUN apt update && apt install -y nginx openssl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Copy configuration and scripts
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/ssl_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ssl_setup.sh

# Generate SSL certificate
RUN /usr/local/bin/ssl_setup.sh

# Expose HTTPS port
EXPOSE 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
