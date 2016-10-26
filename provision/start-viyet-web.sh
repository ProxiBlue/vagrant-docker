#!/bin/bash

echo "STARTING APACHE WEBSERVER"
NAME=`hostname`
BASEFOLDER=/vagrant/machines/$NAME/www/
DOCROOT=$BASEFOLDER/docroot

sudo rm -rf  /var/www/html
sudo ln -s $DOCROOT /var/www/html

if [ ! -f $FOLDER/app/etc/local.xml ]; then
    ln -s $FOLDER/app/etc/local.xml.dev $FOLDER/app/etc/local.xml
fi

sudo service nginx restart
