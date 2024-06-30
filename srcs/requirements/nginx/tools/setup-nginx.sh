#! /bin/bash

# TODO: check sha sums

NGINX_VERSION="1.26.1"
NGINX_NAME="ngnix-$NGINX_VERSION"
NGINX_PATH="$NGINX_NAME.tar.gz"
SSL_VERSION="3.3.1"
SSL_NAME="openssl-$SSL_VERSION"
SSL_PATH="$SSL_NAME.tar.gz"
SSL_KEY_SIZE="4096"

# remove openssl if it is installed
apt remove --purge openssl -y && apt autoremove -y && apt autoclean

# update the container
apt update && upt upgrade -y

# install all dependencies
apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev wget -y

# nginx download and build from source
wget https://nginx.org/download/$NGINX_PATH
tar -zxvf $NGINX_PATH -C /tmp/
cd $NGINX_NAME
./configure
make
make install
cd ..

# openssl download and build from source
wget https://www.openssl.org/source/$SSL_PATH
tar -zxvf $SSL_PATH -C /tmp/
cd $SSL_NAME
./config --prefix=/usr/local --openssldir=/usr/local
make
make install
rm -f /usr/bin/openssl
ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
cd ..

# create self signed certificate
openssl req \
	-x509  \
	-nodes \
	-days 365 \
	-newkey rsa:$SSL_KEY_SIZE \
	-subj "/C=NL/ST=Denial/L=Earth/O=Dis/CN=codam" \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt

# create a nginx user to run nginx
# useradd -M -s /usr/sbin/nologin --uid 1066 --user-group nginx
# apt update && apt install libcap2-bin -y
# setcap CAP_NET_BIND_SERVICE=+eip /nginx
# chown -R /tmp/nginx. /etc/nginx

# create key for Perfect Forward Secrecy
openssl dhparam -out /etc/ssl/certs/dhparam.pem $SSL_KEY_SIZE

# create snippets for nginx

# clean up
rm -f $NGINX_PATH
