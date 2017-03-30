#!/bin/bash


# Install n98-magerun
# --------------------
cd /vagrant/httpdocs
/usr/bin/wget --no-check-certificate https://files.magerun.net/n98-magerun.phar
/bin/chmod +x ./n98-magerun.phar
cp ./n98-magerun.phar /usr/bin/n98-magerun
mkdir -p ~/.n98-magerun/modules/
cd ~/.n98-magerun/modules/
git clone https://github.com/peterjaap/magerun-addons.git pj-addons


service nginx stop
#rm -rf /etc/nginx/*
cp -xav /tmp/magento_nginx/* /etc/nginx/
cp -xav /tmp/www.conf /etc/php-fpm.d/www.conf
cp -xav /tmp/my.cnf /etc/my.cnf

service mysql stop
service php-fpm restart
service nginx restart

#mysqld_safe --skip-grant-tables &

#sleep 10

#mysql -e "CREATE USER 'dev'@'%' IDENTIFIED BY 'dev';"
#mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'dev'@'%';"
#mysql -e "FLUSH PRIVILEGES;"

service mysql restart

cd /vagrant/sites/ntotank/app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
cd /vagrant/sites/protank/app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
cd /vagrant/sites/sprayersupplies/app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi
cd /vagrant/sites/pvcpipesupplies/app/etc
if [ ! -L ./local.xml ] ; then
        ln -s ./local.xml.dev ./local.xml
        n98-magerun db:create
fi

echo l3m0ntr33 | passwd --stdin vagrant

echo "You can remote SSH to 192.168.50.2 using user 'vagrant' with password 'l3m0ntr33'"
echo "Alternatively you can simply use: 'vagrant ssh' to ssh into server without a password"




