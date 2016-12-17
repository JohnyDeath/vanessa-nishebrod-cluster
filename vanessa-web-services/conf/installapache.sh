#!/bin/sh
# This scripts is used to install dependencies

export DEBIAN_FRONTEND=noninteractive
echo "install apache"
echo "deb http://archive.ubuntu.com/ubuntu precise main restricted universe
deb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe
deb http://security.ubuntu.com/ubuntu precise-security main restricted universe multiverse" > /etc/apt/sources.list.d/apache22.list

echo "
Package: *
Pin: release n=precise
Pin-Priority: -10

Package: apache*
Pin: release n=precise
Pin-Priority: 900

" > /etc/apt/preferences.d/apache22-900

apt-get update -y -qq && apt-get install -y -qq apache2 apache2.2-common apache2.2-bin apache2-mpm-worker
pip install watchdog jinja2
