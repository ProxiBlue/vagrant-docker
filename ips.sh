#!/bin/bash

#if curl -s --head  --request GET http://dnsdock.enjo.test | grep "200 OK" > /dev/null; then

    ifconfig eth0:1 172.17.0.100/16 up
    #now inject that into the dnsdock
    curl -s http://dnsdock.enjo.test/services/ntotank -X PUT --data-ascii '{"name": "ntotank", "image": "ntotank", "ip": "172.17.0.100", "ttl": 130}' 2>&1 >/dev/null
    

    ifconfig eth0:2 172.17.0.111/16 up
    #now inject that into the dnsdock
    curl -s http://dnsdock.enjo.test/services/protank -X PUT --data-ascii '{"name": "protank", "image": "protank", "ip": "172.17.0.111", "ttl": 130}' 2>&1 >/dev/null

    ifconfig eth0:3 172.17.0.121/16 up
    #now inject that into the dnsdock
    curl -s http://dnsdock.enjo.test/services/pvcpipesupplies -X PUT --data-ascii '{"name": "pvcpipesupplies", "image": "pvcpipesupplies", "ip": "172.17.0.121", "ttl": 130}' 2>&1 >/dev/null

    ifconfig eth0:4 172.17.0.122/16 up
    #now inject that into the dnsdock
    curl -s http://dnsdock.enjo.test/services/sprayersupplies -X PUT --data-ascii '{"name": "sprayersupplies", "image": "sprayersupplies", "ip": "172.17.0.122", "ttl": 130}' 2>&1 >/dev/null


#fi


