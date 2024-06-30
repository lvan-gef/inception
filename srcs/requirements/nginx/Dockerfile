FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

ENV NGINX_VERSION=1.26.1
ENV SSL_VERSION=3.3.1

WORKDIR /tmp

COPY tools .
RUN sh tools/setup-nginx.sh

# USER nginx

# Expose ports
EXPOSE 443

# run nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
