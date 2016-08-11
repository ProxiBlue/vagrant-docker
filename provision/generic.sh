#!/bin/bash
. /tmp/init.sh
. /tmp/functions.sh

startmysql

case "$VERSION" in
        "empty")
            if [ -f $FOLDER/index.php ]; then
                echo "*****************************************************"
                echo "=> EMPTY install - no code or db"
                echo "=> You need to extract the site into $FOLDER"
                echo "=> setup the database connection (local.xml) and import the db"
                echo "*****************************************************"
                echo "Machine = $NAME"
                echo "*****************************************************"
            else
                echo "*****************************************************"
                echo "=> No Magento Version to install specified"
                echo "=> You need to extract the site into $FOLDER"
                echo "=> setup the database connection and import the db"
                echo "*****************************************************"
                echo "Machine = $NAME"
                echo "*****************************************************"
            fi
        ;;
esac

exit 0