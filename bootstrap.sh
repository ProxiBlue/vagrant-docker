#!/bin/bash

service nginx stop
service php-fpm stop
service mysql stop
mysqld_safe --skip-grant-tables --skip-networking &

# Install n98-magerun
# --------------------
cd ~/
echo "Fetching n98-magerun"
/usr/bin/wget --no-check-certificate https://files.magerun.net/n98-magerun.phar >/dev/null 2>&1
/bin/chmod +x ./n98-magerun.phar
cp ./n98-magerun.phar /usr/bin/n98-magerun
mkdir -p ~/.n98-magerun/modules/
cd ~/.n98-magerun/modules/
git clone https://github.com/peterjaap/magerun-addons.git pj-addons


#rm -rf /etc/nginx/*
cp -xav /tmp/magento_nginx/* /etc/nginx/
cp -xav /tmp/www.conf /etc/php-fpm.d/www.conf
cp -xav /tmp/my.cnf /etc/my.cnf

service php-fpm start
service nginx start

mysql -e "update mysql.user set password=password('root') where user='root';"
mysql -e "FLUSH PRIVILEGES;"
service mysql restart
RET=1
COUNT=0
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup (root/root) $COUNT/3"
    sleep 3
    mysql -uroot -proot -e "status" > /dev/null 2>&1
    RET=$?
    ((COUNT=COUNT+1))
    if [ $COUNT -gt 2 ]; then
        while [[ RET -ne 0 ]]; do
            echo "=> Waiting for confirmation of MySQL service startup (root/none) $COUNT/3"
            sleep 3
            mysql -uroot -e "status" > /dev/null 2>&1
            RET=$?
            ((COUNT=COUNT+1))
            if [ $COUNT -gt 2 ]; then
                RET=0
                break;
            fi
        done
    fi
done
sleep 10
mysql -uroot -proot -e "CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost';"
mysql -uroot -proot -e "CREATE USER 'dev'@'127.0.0.1' IDENTIFIED BY 'dev';"
mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'dev'@'127.0.0.1';"

mysql -uroot -proot -e "FLUSH PRIVILEGES;"

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

echo tanks | passwd --stdin vagrant

echo "You can remote SSH to 192.168.50.2 using user 'vagrant' with password 'tanks'"
echo "Alternatively you can simply use: 'vagrant ssh' to ssh into server without a password"
