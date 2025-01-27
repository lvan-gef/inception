FROM debian:bullseye-slim

ARG CERT_PATH
ARG KEY_PATH
ARG DOMAIN_NAME

RUN apt update && apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout $KEY_PATH \
    -out $CERT_PATH \
    -subj "/C=NL/ST=IDF/L=Amsterdam/O=42/OU=42/CN=$DOMAIN_NAME"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
