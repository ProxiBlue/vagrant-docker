#!/bin/bash

echo "STARTING WEBSERVER"
NAME=`hostname`
BASEFOLDER=/vagrant/machines/$NAME/www/
DOCROOT=$BASEFOLDER/docroot

sudo rm -rf  /var/www/html
sudo ln -s $DOCROOT /var/www/html

if [ ! -f $FOLDER/app/etc/local.xml ]; then
    ln -s $FOLDER/app/etc/local.xml.dev $FOLDER/app/etc/local.xml
fi

cat >/etc/nginx/sites-available/default <<EOL
server {
listen 80;

root /var/www/html/www;
index index.php index.html index.htm;

server_name viyet;

location / {
try_files $uri $uri/ /index.php?q=$uri&$args;
}

error_page 404 /404.html;

error_page 500 502 503 504 /50x.html;
location = /50x.html {
root /usr/share/nginx/www;
}

location ~ .php$ {
fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_read_timeout 1800;
    fastcgi_index index.php;
    fastcgi_intercept_errors on;
    include fastcgi_params;
    fastcgi_buffer_size 128k;
    fastcgi_buffers 4 256k;
    fastcgi_busy_buffers_size 256k;
}

location ~* .(js|css|png|jpg|jpeg|gif|ico)$ {
expires 1y;
}

location ~* .(htm|html)$ {
expires 1m;
}

}


}


EOL

sudo service php5-fpm restart
sudo service nginx force-reload
