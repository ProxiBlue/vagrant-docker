#!/bin/bash

NAME=`hostname`
FOLDER=/vagrant/machines/$NAME/www
echo "=> Starting webserver in $FOLDER"
cd $FOLDER
if [ ! -f $FOLDER/router.php ]; then
    wget https://raw.github.com/philwinkle/Magento-PHP-Webserver-Router/master/router.php
fi
touch /etc/authbind/byport/80
chmod 777 /etc/authbind/byport/80
su -c "MAGE_IS_DEVELOPER_MODE=true authbind --deep /usr/bin/php -S 0.0.0.0:80 $FOLDER/router.php  &" -m "vagrant"
