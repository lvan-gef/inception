FROM debian:bullseye-slim

RUN apt update && apt install -y nginx openssl curl

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN openssl req -x509 -nodes -days 31 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=NL/ST=IDF/L=Amsterdam/O=42/OU=42/CN=lvan-gef.42.fr"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
