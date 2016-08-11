#!/bin/bash
. /tmp/init.sh
. /tmp/functions.sh

startmysql

echo "=> Creating MySQL magento user with 'magento' password"
mysql -uroot -e "CREATE USER 'magento'@'%' IDENTIFIED BY 'magento'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'magento'@'%' WITH GRANT OPTION"
mysql -uroot -e "create database \`magentodb\`;"
mysql -uroot -e "flush privileges;"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -umagento -pmagento "
echo "    default magento db is called magentodb"
echo ""
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

