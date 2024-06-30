FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

ENV VERSION=1.26.1

# install nginx from source
RUN apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev wget -y
RUN wget https://nginx.org/download/nginx-${VERSION}.tar.gz && \
    tar -zxvf nginx-${VERSION}.tar.gz && \
    cd nginx-${VERSION} && \
    ./configure && \
    make && \
    make install


CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Expose ports
EXPOSE 443
