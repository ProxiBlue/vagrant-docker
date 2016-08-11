#!/bin/bash

echo "STARTING APACHE WEBSERVER"
NAME=`hostname`
FOLDER=/vagrant/machines/$NAME/www

sudo sed -i 's%</VirtualHost>%<Directory "/var/www/html">\nAllowOverride  All\n </Directory>\n</VirtualHost>%g' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's%;always_populate_raw_post_data = -1%always_populate_raw_post_data = -1%g' /etc/php5/apache2/php.ini
sudo sed -i 's%/var/www/html/www%/var/www/html/www%; t; s%/var/www/html%/var/www/html/www%;' /etc/apache2/sites-available/000-default.conf


sudo rm -rf  /var/www/html
sudo ln -s $FOLDER /var/www/html
sudo a2enmod rewrite
sudo a2enmod headers

if [ ! -f $FOLDER/www/.htacess ]; then
    ln -s $FOLDER/www/.htaccess.dev $FOLDER/www/.htaccess
fi

if [ ! -f $FOLDER/app/etc/local.xml ]; then
    ln -s $FOLDER/app/etc/local.xml.dev $FOLDER/app/etc/local.xml
fi

sudo service apache2 start
