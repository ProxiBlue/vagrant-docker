#!/bin/bash

. /tmp/init.sh

wget http://dev.mysql.com/get/mysql-apt-config_0.3.5-1debian8_all.deb /tmp/mysql-apt-config.deb
DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config.deb

apt-get update \
     && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential automake checkinstall sendmail openssh-server supervisor sudo \
     apache2 wget curl net-tools iptables authbind mysql-server build-essential \
     git ssh bash php5 php5-cli php5-mysql php5-curl php5-gd pv \
     php5-mcrypt php5-xdebug php5-intl php5-xsl unzip bzip2 pwgen joe vim ant dos2unix ruby-dev \
     && apt-get clean

gem install ffi -v '1.9.8'
gem install bundler --pre

sed -i "s%bind-address%#bind-address%g" /etc/mysql/my.cnf
echo "skip-grant-tables = 1" >> /etc/mysql/my.cnf

cd $FOLDER

find $FOLDER -type f -exec dos2unix {} \;

echo "nameserver 8.8.8.8" >/etc/resolv.conf



