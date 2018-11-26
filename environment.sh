#!/bin/bash

echo "nameserver `/sbin/ip route|awk '/default/ { print $3 }'`" >/etc/resolv.conf
