#!/bin/bash

if [ ! -f /usr/local/bin/phpunit.phar ]; then
    echo "=> Instaling phpunit.phar"
    cd /
    wget https://phar.phpunit.de/phpunit.phar
    /bin/chmod a+rwx phpunit.phar
    mv phpunit.phar /usr/local/bin/phpunit.phar
    echo "=> Done!"
else
    echo "=> composer is already installed"
fi