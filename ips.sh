#!/bin/bash

source /home/vagrant/myvars.sh
DNSDOCK=dnsdock.${DEV_DOMAIN}

echo USING: $DNSDOCK

echo "nameserver 172.17.0.1" >/etc/resolv.conf


echo "==================== SETTING IPS ==========================="

ifconfig eth0:1 172.17.0.100/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/ntotank -X PUT --data-ascii '{"name": "ntotank", "image": "ntotank", "ip": "172.17.0.100", "ttl": 130}' 2>&1 >/dev/null


ifconfig eth0:2 172.17.0.111/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/protank -X PUT --data-ascii '{"name": "protank", "image": "protank", "ip": "172.17.0.111", "ttl": 130}' 2>&1 >/dev/null

ifconfig eth0:3 172.17.0.121/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/pvcpipesupplies -X PUT --data-ascii '{"name": "pvcpipesupplies", "image": "pvcpipesupplies", "ip": "172.17.0.121", "ttl": 130}' 2>&1 >/dev/null

ifconfig eth0:4 172.17.0.122/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/sprayersupplies -X PUT --data-ascii '{"name": "sprayersupplies", "image": "sprayersupplies", "ip": "172.17.0.122", "ttl": 130}' 2>&1 >/dev/null

ifconfig eth0:5 172.17.0.123/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/pvcm2 -X PUT --data-ascii '{"name": "pvcm2", "image": "pvcm2", "ip": "172.17.0.123", "ttl": 130}' 2>&1 >/dev/null

ifconfig eth0:6 172.17.0.130/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/protankequipment -X PUT --data-ascii '{"name": "protankequipment", "image": "protankequipment", "ip": "172.17.0.130", "ttl": 130}' 2>&1 >/dev/null

ifconfig eth0:7 172.17.0.140/16 up
#now inject that into the dnsdock
curl -s http://$DNSDOCK/services/bestwayag -X PUT --data-ascii '{"name": "bestwayag", "image": "bestwayag", "ip": "172.17.0.140", "ttl": 130}' 2>&1 >/dev/null


curl -s http://$DNSDOCK/services | python -m json.tool

