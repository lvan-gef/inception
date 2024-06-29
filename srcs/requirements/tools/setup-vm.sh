#! /bin/bash

# this script will be run as root after the first boot of the vm
# have to do it manually

# update the system
apt update && apt upgrade -y

# add user luuk so we dont have to login as root all the time
# todo: see if we can restrict luuk from what i can do with sudo??
apt install sudo
usermod -aG luuk

# https://docs.docker.com/engine/install/debian/
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

# install docker
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin