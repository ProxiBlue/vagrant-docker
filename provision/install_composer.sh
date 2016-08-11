#!/bin/bash

if [ ! -f /usr/local/bin/composer ]; then
    echo "=> Instaling Composer"
    cd /
    /usr/bin/php -r "readfile('https://getcomposer.org/installer');" | /usr/bin/php
    /bin/chmod a+rwx composer.phar
    mv composer.phar /usr/local/bin/composer
    echo "=> Done!"
else
    echo "=> composer is already installed"
fi