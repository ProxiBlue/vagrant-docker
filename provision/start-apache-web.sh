#!/bin/bash

echo "STARTING APACHE WEBSERVER"
NAME=`hostname`
BASEFOLDER=/vagrant/machines/$NAME/www/
DOCROOT=$BASEFOLDER/docroot

sudo a2ensite default-ssl.conf

sudo sed -i 's%</VirtualHost>%<Directory "/var/www/html">\nAllowOverride  All\n </Directory>\n</VirtualHost>%g' /etc/apache2/sites-available/default-ssl.conf
sudo sed -i 's%</VirtualHost>%<Directory "/var/www/html">\nAllowOverride  All\n </Directory>\n</VirtualHost>%g' /etc/apache2/sites-available/000-default.conf
sudo sed -i 's%;always_populate_raw_post_data = -1%always_populate_raw_post_data = -1%g' /etc/php5/apache2/php.ini

sudo rm -rf  /var/www/html
sudo ln -s $DOCROOT /var/www/html
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl


if [ ! -f $DOCROOT/.htacess ]; then
    ln -s $BASEFOLDER/.htaccess.dev $DOCROOT/.htaccess
fi

sudo service apache2 restart
