#!/bin/bash

chown -R www-data.vagrant .
find . -type f -exec chmod 777 {} \;
find . -type d -exec chmod 777 {} \; 
find var/ -type f -exec chmod 777 {} \; 
find media/ -type f -exec chmod 777 {} \;
find var/ -type d -exec chmod 777 {} \; 
find media/ -type d -exec chmod 777 {} \;
chmod 777 includes
chmod 777 includes/config.php

