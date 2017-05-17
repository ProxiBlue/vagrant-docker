#!/bin/bash

/etc/init.d/redis-server start
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
/etc/init.d/mysqld start