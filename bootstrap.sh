#!/bin/bash

/etc/init.d/mysqld start
cp -xav /tmp/magento_nginx/* /etc/nginx/
chown root:root /etc/nginx/ -R
#cp -xav /tmp/www.conf /etc/php-fpm.d/www.conf

/etc/init.d/php54-php-fpm start
service nginx restart

cd /vagrant/sites/ntotank
if [ -e ./composer.json ] ; then
    composer update
fi
dos2unix /vagrant/sites/ntotank/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi

cd /vagrant/sites/protank
if [ -e ./composer.json ] ; then
    composer update
fi
npm install
dos2unix /vagrant/sites/protank/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
cd /vagrant/sites/sprayersupplies
if [ -e ./composer.json ] ; then
    composer update
fi
dos2unix /vagrant/sites/sprayersupplies/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
cd /vagrant/sites/pvcpipesupplies
if [ -e ./composer.json ] ; then
    composer update
fi
dos2unix /vagrant/sites/pvcpipesupplies/shell/*.sh
cd app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi

echo "cd /vagrant/sites" >> /home/vagrant/.bashrc

echo "You can remote SSH to 192.168.50.2 using user 'vagrant' with password 'tanks'"
echo "Alternatively you can simply use: 'vagrant ssh' to ssh into server without a password"
