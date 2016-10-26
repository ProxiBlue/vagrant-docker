#!/bin/bash
# I have no idea why this exists.
# I think I created it as a workaround for the virtualbox guest and mysql not starting up
# need to re-assess if still needed

startmysql() {
    sudo /usr/bin/mysqld_safe > /dev/null 2>&1 &
    RET=1
    COUNT=0

    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of MySQL service startup (root/root) $COUNT/5"
        sleep 3
        mysql -uroot -proot -e "status" > /dev/null 2>&1
        RET=$?
        ((COUNT=COUNT+1))
        if [ $COUNT -gt 2 ]; then
            while [[ RET -ne 0 ]]; do
                echo "=> Waiting for confirmation of MySQL service startup (root/none) $COUNT/3"
                sleep 3
                mysql -uroot -e "status" > /dev/null 2>&1
                RET=$?
                ((COUNT=COUNT+1))
                if [ $COUNT -gt 5 ]; then
                    RET=0
                    break;
                fi
            done
        fi
    done

}

