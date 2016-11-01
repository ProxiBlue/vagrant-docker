#!/bin/bash

NAME=`hostname`
BASEFOLDER=/vagrant/machines/viyet/www/
DOCROOT=$BASEFOLDER/docroot

if [ ! -f $DOCROOT/app/etc/local.xml ]; then
    ln -s $DOCROOT/app/etc/local.xml.dev $DOCROOT/app/etc/local.xml
fi

cat >/etc/nginx/sites-available/default <<'EOL'
server {
  listen 80 default_server;

  server_name *.viyet.proxiblue.dev viyet.proxiblue.dev;

  allow all;

  root /vagrant/machines/viyet/www/docroot/www/;
  index index.php;
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  large_client_header_buffers 4 32k;

  location ~* (.+)\.(\d+)\.(js|css|png|jpg|jpeg|gif)$ {
    try_files $uri $1.$3;
    access_log off;
    expires max;
  }

  location / {
    index index.html index.php;
    try_files $uri $uri/ @handler;
    expires 30d;
  }

  location  /. {
    return 404;
  }

  location @handler {
    rewrite / /index.php;
  }

  location ~ .php/ {
    fastcgi_read_timeout 1800;
    rewrite ^(.*.php)/ $1 last;
  }

  location ~ \.php$ {
    if (!-e $request_filename) {
      rewrite / /index.php last;
    }

    expires off;

    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_read_timeout 1800;
    fastcgi_index index.php;
    fastcgi_intercept_errors on;
    fastcgi_param SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    fastcgi_param MAGE_RUN_TYPE store;
    include fastcgi_params;
    fastcgi_buffer_size 128k;
    fastcgi_buffers 4 256k;
    fastcgi_busy_buffers_size 256k;

  }

  location ~ /\.ht {
    deny all;
  }

  location /api {
    rewrite ^/api/rest /api.php?type=rest;
  }

  location ~* (.+)\.(\d+)\.(js|css|png|jpg|jpeg|gif)$ {
    try_files $uri $1.$3;
  }

}

EOL

service php5-fpm restart
chmod 777 /var/run/php*
sudo service nginx restart