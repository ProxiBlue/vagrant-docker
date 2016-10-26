#!/bin/bash
. /tmp/init.sh
. /tmp/functions.sh

startmysql

#place any final provisioning commands here
export PHP_IDE_CONFIG="serverName=broker.biz"


exit 0