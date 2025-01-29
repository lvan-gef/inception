#! /bin/bash

# for debian
# this script will be run as root after the first boot of the vm

# update and install deps
apt update && apt upgrade -y && apt install git ca-certificates curl rsync make -y

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

# install docker docker-compose and all deps
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose docker-ce-rootless-extras dbus-user-session slirp4netns docker-ce-rootless-extras uidmap -y

# run docker root-less script  switch to normal user
su - inception
sh /usr/bin/dockerd-rootless-setuptool.sh install
exit

# setup neovim
apt install ninja-build gettext cmake curl build-essential gcc -y
mkdir /home/inception/build_dir
cd /home/inception
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && dpkg -i nvim-linux64.deb
rsync -az --rsh='ssh -p2222' ~/.config/nvim inception@localhost:/home/inception/.config

# nginx give a error and this solved it
setcap cap_net_bind_service=+ep $(which rootlesskit)
sysctl -w net.ipv4.ip_unprivileged_port_start=443

# restart vm
reboot
