#!/bin/bash

NAME=`hostname`
VERSION=$1
FOLDER=/vagrant/machines/$NAME/www
echo "=> Setup $NAME into $FOLDER"
mkdir $FOLDER -p
cd $FOLDER