#!/bin/bash
. /tmp/init.sh
. /tmp/functions.sh

startmysql

echo "=> Creating MySQL user 'root' with password 'root'"
mysql -uroot -e "CREATE USER 'root'@'%' IDENTIFIED BY 'root'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION"
mysql -uroot -e "create database \`database\`;"
mysql -uroot -e "flush privileges;"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uroot -proot "
echo "    default db is called: database"
echo ""
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

