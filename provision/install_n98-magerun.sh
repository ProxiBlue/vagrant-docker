#!/bin/bash

if [ ! -f /usr/local/bin/n98-magerun ]; then
    echo "=> Instaling n98-magerun"
    cd /tmp
    /usr/bin/wget --no-check-certificate https://files.magerun.net/n98-magerun.phar
    /bin/chmod +x ./n98-magerun.phar
    cp ./n98-magerun.phar /usr/local/bin/n98-magerun
    echo "=> Done!"
    # install plugins
    mkdir -p /home/vagrant/.n98-magerun/modules/
    cd /home/vagrant/.n98-magerun/modules/
    git clone https://github.com/kalenjordan/magerun-addons
    git clone https://github.com/peterjaap/magerun-addons.git pj-addons
else
    echo "=> n98-magerun is already installed"
fi

