FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

ENV VERSION 1.22.0

RUN apt install build-essential build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev wget
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure && \
    make && \
    make install

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Expose ports
EXPOSE 80
