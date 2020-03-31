#!/bin/bash

export DEV_DOMAIN=$1
export WEB_IP=$2

echo "export DEV_DOMAIN=$1" > /home/vagrant/myvars.sh

echo "nameserver 1.1.1.1" >/etc/resolv.conf
echo "nameserver 8.8.8.8" >>/etc/resolv.conf

id -u seluser &>/dev/null || useradd seluser \
         --shell /bin/bash  \
         --create-home \
  && usermod -a -G sudo seluser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'seluser:secret' | chpasswd
echo "cd /vagrant/sites/" >> /home/vagrant/.bashrc

/bin/bash /vagrant/setnginxconf.sh

sed -i 's/{{DEV_DOMAIN}}/'"$DEV_DOMAIN"'/g' /etc/nginx/sites-enabled/*

cp /vagrant/self-signed.conf /etc/nginx/snippets/
cp /vagrant/ssl-params.conf /etc/nginx/snippets/
cp -xa /vagrant/ssl/* /etc/ssl/
cp -xa /vagrant/php-fpm/www.conf.php7 /etc/php/7.1/fpm/pool.d/www.conf
cp -xa /vagrant/php-fpm/www.conf.php56 /etc/php/5.6/fpm/pool.d/www.conf

cp -xa /vagrant/php-fpm/* /etc/php/7.2/fpm/pool.d/
[ -d /home/vagrant/.composer ] || mkdir /home/vagrant/.composer
cp -xa /vagrant/auth.json /home/vagrant/.composer/auth.json
chown vagrant:vagrant /home/vagrant/.composer -R
sudo sed -i '/x-frame-options: DENY/d' /etc/nginx/snippets/ssl-params.conf

# ref: https://www.scalix.com/wiki/index.php?title=Configuring_Sendmail_with_smarthost_Ubuntu_Gutsy

if [ ! -d /home/vagrant/.n98-magerun/modules ]; then
    mkdir -p /home/vagrant/.n98-magerun/modules/
    mkdir /home/vagrant/.n98-magerun/modules/
    cd /home/vagrant/.n98-magerun/modules/
    git clone https://github.com/peterjaap/magerun-addons.git pj-addons
    chown vagrant:vagrant /home/vagrant/.n98-magerun -R
fi

if [ -f /tmp/magento ]; then
    rm -rf /tmp/magento
fi

