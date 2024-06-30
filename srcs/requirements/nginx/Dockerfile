FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

ENV NGINX_VERSION=1.26.1
ENV SSL_VERSION=3.3.1

# install nginx from source
WORKDIR /tmp
RUN apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev wget -y
RUN wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure && \
    make && \
    make install

# install openssh from source
RUN wget https://www.openssl.org/source/openssl-${SSL_VERSION}.tar.gz && \
	tar -zxvf openssl-${SSL_VERSION}.tar.gz && \
	cd openssl-${SSL_VERSION} && \
	./config --prefix=/usr/local --openssldir=/usr/local && \
	make && \
	make install && \
	rm -f /usr/bin/openssl && \
	ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl

# generate self signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

# create key for Perfect Forward Secrecy
# RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

# create a nginx user to run nginx
# RUN useradd -M -s /usr/sbin/nologin --uid 1066 --user-group nginx && \
# 	apt update && apt install libcap2-bin -y && \
# 	setcap CAP_NET_BIND_SERVICE=+eip /nginx && \
# 	chown -R /tmp/nginx. /etc/nginx
#
# USER nginx

# Expose ports
EXPOSE 443

# clean up
RUN rm -f nginx-${NGINX_VERSION}.tar.gz openssl-${SSL_VERSION}.tar.gz

# run nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
