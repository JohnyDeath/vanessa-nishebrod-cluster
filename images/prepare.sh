#!/bin/bash

sudo curl -sSL https://get.docker.com/ | sh;

sudo apt-get install zfs-fuse -y -q

docker version

echo "Installing compose"

curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

docker-compose --version

echo "Prepare all"

ufw allow ssh && ufw allow 80/tcp && ufw allow 443/tcp && ufw show added && ufw --force enable

echo "Europe/Moscow" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

apt-get update
apt-get -y upgrade

apt-get install --yes ntp

fallocate -l 4G /swapfile && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile

sudo sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'
