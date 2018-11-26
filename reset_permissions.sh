#!/bin/bash
#
# Found on StackOverflow:
# http://stackoverflow.com/a/9304264/3765
#

if [ ! -f ./app/etc/local.xml.template ]; then
    echo "-- ERROR"
    echo "-- This doesn't look like a Magento install.  Please make sure"
    echo "-- that you are running this from the Magento main doc root dir"
    exit
fi

if [ `id -u` != 0 ]; then
    echo "-- ERROR"
    echo "-- This script should be run as root so that file ownership"
    echo "-- changes can be set correctly"
    exit
fi

chown vagrant:www-data .* -R

find . -type f \-exec chmod 644 {} \;
find . -type d \-exec chmod 755 {} \;

find ./var -type d \-exec chmod 777 {} \;
find ./var -type f \-exec chmod 666 {} \;

find ./media -type d \-exec chmod 777 {} \;
find ./media -type f \-exec chmod 666 {} \;

chmod 777 ./app/etc
chmod 644 ./app/etc/*.xml

