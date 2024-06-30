FROM debian:bullseye-slim

RUN apt update && apt upgrade -y

# prerequisites for ngnix
RUN apt install curl gnupg2 ca-certificates lsb-release debian-archive-keyring wget -y

# add signing key
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null

# do some keychecking
# RUN gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg

# add nginx-stable to the apt repolist
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
	https://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

# pinned the nginx repo over distro repo
RUN echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

# update and install nginx
RUN apt update && apt install nginx -y

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Expose ports
EXPOSE 443
