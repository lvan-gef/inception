FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

WORKDIR /tmp

COPY tools tools
RUN sh tools/setup-nginx.sh

# USER nginx

# Expose ports
EXPOSE 443

# run nginx
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
