#! /bin/bash

# this script will be run as root after the first boot of the vm
# have to do it manually

# have to install git manually because the minimal version of debian dont ship with it by default
# and clone it manually

# update and install deps
apt update && apt upgrade -y && apt install sudo vim git ca-certificates curl rsync -y

# add user luuk so we dont have to login as root all the time
# todo: see if we can restrict luuk from what it can do with sudo??
# usermod -aG sudo luuk
# adder="luuk ALL=(ALL:ALL) NOPASSWD: ALL"
# grep "$adder" /etc/sudoers
# if [ $? -ne 0 ]; then
# 	echo "$adder" >> /etc/sudoers
# fi

# https://docs.docker.com/engine/install/debian/
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
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.32.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# add user luuk to docker
groupadd docker
usermod -aG docker luuk
