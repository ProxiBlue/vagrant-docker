#!/bin/bash

IP=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
VERSION=`hostname`
FOLDER=/vagrant/projects/$VERSION/www
echo $FOLDER
if [ -f $FOLDER/index.php ]; then
    echo "=> Fixing host in local.xml to be to $IP"
    sed -i "s%<host>.*</host>%<host>$IP</host>%g" $FOLDER/app/etc/local.xml

    echo "=> Starting webserver in $FOLDER for $IP"
    cd $FOLDER
    if [ ! -f $FOLDER/router.php ]; then
        wget https://raw.github.com/philwinkle/Magento-PHP-Webserver-Router/master/router.php
    fi
    touch /etc/authbind/byport/80
    chmod 777 /etc/authbind/byport/80

    su -c "MAGE_IS_DEVELOPER_MODE=true authbind --deep /usr/bin/php -S $IP:80 $FOLDER/router.php  " -m "vagrant"
else
    echo "NO CODE FOUND, NO WEB SERVER STARTED"
    echo "to satrt a webserver ssh to image and run /vagrant/provision/start-php-web.sh"
fi
