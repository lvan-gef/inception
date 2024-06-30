FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

ENV NGINX-VERSION=1.26.1
ENV SSL-VERSION=3.3.1

# install nginx from source
WORKDIR /tmp
RUN apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev wget -y
RUN wget https://nginx.org/download/nginx-${NGINX-VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX-VERSION}.tar.gz && \
    cd nginx-${NGINX-VERSION} && \
    ./configure && \
    make && \
    make install

# install openssh from source
RUN wget https://www.openssl.org/source/openssl-${SSL-VERSION}.tar.gz && \
	tar -zxvf openssl-${SSL-VERSION}.tar.gz && \
	cd openssl-${SSL-VERSION} && \
	./conf --prefix=/usr/local --openssldir=/usr/local && \
	make && \
	make install && \
	rm -f /usr/bin/openssl && \
	ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Expose ports
EXPOSE 443
